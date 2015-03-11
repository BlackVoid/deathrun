util.AddNetworkString( "DeathRun_RoundResult" )
util.AddNetworkString( "DeathRun_RoundStart" )
util.AddNetworkString( "DeathRun_LastWinner" )

GM.RoundStart = os.time()
GM.RoundEnd = os.time()
GM.NextMap = ""
GM.VoteNextRound = false
GM.ForceChange = false
GM.InitSpawn = false
GM.LastWinner = 0
SetGlobalInt("DeathRun_TimeLeft", GM.RoundLength:GetInt())

local pmeta = FindMetaTable("Player")

timer.Create("DeathRun_CheckGameState", 10, 0, function()
	if GAMEMODE.Debug:GetInt() == 1 then return end
	if GAMEMODE:GetGameState() != STATE_WAITING_FOR_PLAYERS then
		GAMEMODE:RoundStatusCheck()
	end
end)


function GM:CanStartRound()
	if #team.GetPlayers( TEAM_RUN ) + #team.GetPlayers( TEAM_DEATH ) >= self.MinPlayers:GetInt() then return true end
	return false
end

function GM:MapVoteCheck( round )
	if round == self.RoundLimit:GetInt()+1 then
		local map = hook.Call("MapVoteNext", self)
		if map == false then return end
		
		if map != nil then
			RunConsoleCommand("changelevel", map)
			return
		else
			local Maps = {}
			for _,v in ipairs({"dr_", "deathrun_"}) do
				local files, directories = file.Find( "maps/" .. v .. "*.bsp", "GAME" )
				for k,_ in ipairs(files) do
					files[k] = string.Left(files[k], #files[k]-4)
				end
				table.Add(Maps, files)
			end

			for k,v in RandomPairs(Maps) do
				if v == game.GetMap() then continue end
				RunConsoleCommand("changelevel", v)
				break
			end
		end
	end
end

function GM:OnPreRoundStart( num )
	if hook.Call("CanStartRound", self) == false then
		if self:GetGameState() != STATE_WAITING_FOR_PLAYERS then
			self:RoundStatusCheck()
		end
		return
	end

	self:MapVoteCheck( num )

	self:SetGameState(STATE_ROUND_IN_PROGRESS)
	game.CleanUpMap()

	local AllPlayers = self:GetActivePlayers()
	local NrActivePlayers = #AllPlayers
	local PreviousDeath = team.GetPlayers(TEAM_DEATH)

	if NrActivePlayers >= self.MinPlayers:GetInt() then
		
		local NrDeath = math.ceil( NrActivePlayers/self.PlayerToCombineRatio:GetInt() )
		local count=0
		for _, v in RandomPairs( AllPlayers ) do
			if count < NrDeath && !table.HasValue(PreviousDeath, v) then
				v:SetTeam( TEAM_DEATH )
				player_manager.SetPlayerClass( v, "death" )
				count=count+1
			else
				v:SetTeam( TEAM_RUN )	
				player_manager.SetPlayerClass( v, "runner" )
			end

			v:Spawn()
			v:UnSpectate()
			v:Freeze(true)
		end
	end
	SetGlobalInt("DeathRun_TimeLeft", self.RoundLength:GetInt())

	self.TouchEvents:CheckAll()
	GAMEMODE.InitSpawn = true

	timer.Simple(self.RoundPreStartTime:GetInt(), function()
		hook.Call("OnRoundStart", self, num + 1)
	end)
end

function GM:OnRoundEnd(winner)
	self:SetGameState(STATE_ROUND_OVER)
	if #player.GetAll() > 2 then
		if Themis and Themis.Shop and Themis.Shop.GiveCoinsMultiple then
			Themis.Shop.GiveCoinsMultiple(team.GetPlayers(winner), self.CoinsPerRound:GetInt())
		elseif PS then
			for k,v in pairs(team.GetPlayers(winner)) do
				v:PS_GivePoints(self.CoinsPerRound:GetInt())
			end
		elseif Pointshop2 then
			for k,v in pairs(team.GetPlayers(winner)) do
				v:PS2_AddStandardPoints(self.CoinsPerRound:GetInt())
			end
		end
	end

	for k,v in pairs(team.GetPlayers(winner)) do
		v:AddFrags( 1 )
	end

	timer.Destroy("DeathRun_RoundEndTimer")
	timer.Destroy("DeathRun_UpdateRoundTime")
	timer.Destroy("DeathRun_InitSpawn")

	team.AddScore(winner, 1)
	self.LastWinner = winner
	
	net.Start("DeathRun_RoundResult")
	net.WriteInt(winner, 4)
	net.Broadcast()

	timer.Create("DeathRun_DelayNewRound", self.RoundPostEndTime:GetInt() - self.RoundPreStartTime:GetInt(), 1, function()
		hook.Call("OnPreRoundStart", self, self:GetRound() + 1)
	end)
end

function GM:RoundStatusCheck()
	if self:CanStartRound() == false and self:GetGameState() != STATE_WAITING_FOR_PLAYERS then
		self:SetGameState(STATE_WAITING_FOR_PLAYERS)
		SetGlobalInt("DeathRun_TimeLeft", self.RoundLength:GetInt())
		for k,v in pairs(self:GetActivePlayers()) do
			v:SetTeam(TEAM_RUN)
			v:StripWeapons()
			v:Kill()
			v:Spectate(OBS_MODE_ROAMING)
			v:CrosshairDisable()
		end
		timer.Destroy("DeathRun_RoundEndTimer")
		timer.Destroy("DeathRun_UpdateRoundTime")
		timer.Destroy("DeathRun_InitSpawn")
	elseif self:GetGameState() == STATE_ROUND_IN_PROGRESS and (self:NumAliveInTeam( TEAM_RUN ) == 0 or GAMEMODE:NumAliveInTeam( TEAM_DEATH ) == 0) then
		local WinningTeam
		if self:NumAliveInTeam( TEAM_DEATH ) == 0 then
			WinningTeam = TEAM_RUN
		else
			WinningTeam = TEAM_DEATH
		end
		hook.Call("OnRoundEnd", self, WinningTeam)
	end
end

function GM:OnRoundStart(round)
	self.RoundEnd = os.time() + self.RoundLength:GetInt()
	self.RoundStart = os.time()
	self.InitSpawn = true

	local AllPlayers = table.Add(team.GetPlayers( TEAM_RUN ), team.GetPlayers( TEAM_DEATH ))
	for _, v in pairs(AllPlayers) do
		v:Freeze(false)
	end
	self:NextRound()

	net.Start("DeathRun_RoundStart")
	net.WriteInt(self:GetRound(), 8)
	net.Broadcast()

	timer.Create("DeathRun_UpdateRoundTime", 1, self.RoundLength:GetInt(), function()
		SetGlobalInt("DeathRun_TimeLeft", math.Clamp(math.Round(self.RoundEnd-os.time()), 0, GAMEMODE.RoundLength:GetInt()))
	end)

	timer.Create("DeathRun_InitSpawn", self.InitSpawnLength:GetInt(), 1, function()
		GAMEMODE.InitSpawn = false
	end)

	timer.Create("DeathRun_RoundEndTimer", self.RoundLength:GetInt(), 1, function()
		SetGlobalInt("DeathRun_TimeLeft", 0)
		self:OnRoundEnd(TEAM_DEATH)
	end)
end
