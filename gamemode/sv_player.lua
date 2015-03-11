function GM:ShowTeam(ply)
	net.Start("DeathRun_OpenSelectTeamMenu")
	net.Send(ply)
end

function GM:PlayerInitialSpawn(ply)
	if !ply or !IsValid(ply) then return end
	ply:SetTeam(TEAM_SPECTATOR)
	ply:DeathrunSync()

	player_manager.SetPlayerClass( ply, "runner" )

	self:PlayerSetModel(ply)
	timer.Simple(0,function()
		ply:KillSilent()
		ply:Spectate(OBS_MODE_ROAMING)
	end)
end

function GM:GetFallDamage(ply, flFallSpeed)
	if ( self.RealisticFallDamage:GetInt() == 1 ) then
		return flFallSpeed / 9
	end
	
	return 10
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerDeathThink(ply)
	return false
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	if ply:Team() == TEAM_SPECTATOR then return end
	ply:CreateRagdoll()
	if ply:Team() == TEAM_RUN then
		GAMEMODE.InitSpawn = false
	end
	local soundTbl = GAMEMODE.Sounds[ply:Team() == TEAM_RUN and 'CitizenDeath' or 'CombineDeath']

	ply:EmitSound(soundTbl[math.random(#soundTbl)])

	if !IsValid(attacker) then return end
	if attacker:IsPlayer() and attacker:Team() != ply:Team() then
		if Themis and Themis.Shop then
			attacker:ThemisShop_GiveCoins(self.CoinsPerKill:GetInt())
		elseif PS then
			attacker:PS_GivePoints(self.CoinsPerKill:GetInt())
		elseif Pointshop2 then
			attacker:PS2_AddStandardPoints(self.CoinsPerKill:GetInt())
		end
	end
end

function GM:PlayerDeath(victim, weapon, killer)
	if ( victim:IsOnFire() ) then
		victim:Extinguish()
	end
	timer.Simple(0,function()
		self:RoundStatusCheck()
		victim:Spectate(OBS_MODE_ROAMING)	
		victim:CrosshairDisable()
	end)
end

function GM:PlayerSelectSpawn( ply )
	local spawns = ents.FindByClass(ply:Team() == TEAM_DEATH and "info_player_terrorist" or "info_player_counterterrorist")
    return spawns[math.random(#spawns)]
end

function GM:PlayerSpawn(ply)
	if ply:Team() == TEAM_SPECTATOR then return end
	self.BaseClass:PlayerSpawn( ply )
	ply:CrosshairEnable()
	ply:SetAvoidPlayers(false)
	
	timer.Simple(0.5, function()
		self:SetHands(ply)
	end)
end

function GM:PlayerSetModel(ply)
	player_manager.RunClass( ply, "SetModel" )
end

function GM:PlayerNoClip(ply)
	return ply:IsSuperAdmin() and !ply:IsObserver()
end

function GM:PlayerDisconnected(ply)
	timer.Simple(0, function()
		self:RoundStatusCheck()
	end)
end

function GM:SetHands(ply)
	local oldhands = ply:GetHands()
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		ply:SetHands( hands )
		hands:SetOwner( ply )

		-- Which hands should we use?
		local cl_playermodel = (self.ReverseModelList[ply:GetModel()] and self.ReverseModelList[ply:GetModel()] or "refugee01")
		local info = player_manager.TranslatePlayerHands( cl_playermodel )
		if ( info ) then
			hands:SetModel( info.model )
			hands:SetSkin( info.skin )
			hands:SetBodyGroups( info.body )
		end

		-- Attach them to the viewmodel
		local vm = ply:GetViewModel( 0 )
		hands:AttachToViewmodel( vm )

		vm:DeleteOnRemove( hands )
		ply:DeleteOnRemove( hands )

		hands:Spawn()
 	end
end

function GM:EntityTakeDamage( target, dmginfo )
	if ( target:IsPlayer() and dmginfo:GetInflictor() and dmginfo:GetInflictor():IsPlayer() and dmginfo:GetInflictor():Team() == target:Team() ) then
		dmginfo:SetDamage( 0 )
	end
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	return true
end

function GM:ShouldCollide(ent1, ent2)
	if ent1:IsPlayer() and ent2:IsPlayer() and ent1:Team() == ent2:Team() then
		return false
	end
end

function GM:PlayerCanPickupItem(ply, ent)
	return false
end

function GM:CanPlayerSuicide( ply )
        if not ply:Alive() then return false end
        if ply:Team() == TEAM_DEATH then return false end
        if self:GetGameState() == STATE_WAITING_FOR_PLAYERS then return false end

        return self.BaseClass:CanPlayerSuicide( ply )
end

net.Receive("DeathRun_SelectTeam", function (length, ply)
	local option = net.ReadInt(4)
	if option == 1 and ply:Team() == TEAM_SPECTATOR then
		ply:SetTeam(TEAM_RUN)
		ply:KillSilent()
		ply:Spectate(OBS_MODE_ROAMING)
		if GAMEMODE.InitSpawn then
			local NrDeath = math.ceil( #GAMEMODE:GetActivePlayers()/GAMEMODE.PlayerToCombineRatio:GetInt() )
			if #team.GetPlayers( TEAM_DEATH ) < NrDeath then
				ply:SetTeam( TEAM_DEATH )	
				player_manager.SetPlayerClass( ply, "death" )
			else
				ply:SetTeam( TEAM_RUN )	
				player_manager.SetPlayerClass( ply, "runner" )
			end
			ply:Spawn()
			ply:UnSpectate()
			ply:CrosshairEnable()
			ply:SetAvoidPlayers(false)
		end
	elseif option == 2 and ply:Team() != TEAM_SPECTATOR then
		if ply:Team() == TEAM_DEATH then
			GAMEMODE.InitSpawn = false
		end
		ply:SetTeam(TEAM_SPECTATOR)
		ply:Kill()
		ply:Spectate(OBS_MODE_ROAMING)
	end
	if GAMEMODE:GetGameState() == STATE_WAITING_FOR_PLAYERS then
		hook.Call("OnPreRoundStart", GAMEMODE, GAMEMODE.Round + 1)
	end
end)