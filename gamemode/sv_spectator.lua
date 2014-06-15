-- Modified from Fretta

function GM:GetValidSpectatorModes( ply )
	return GAMEMODE.ValidSpectatorModes
end

function GM:GetValidSpectatorEntityNames( ply )
	return GAMEMODE.ValidSpectatorEntities
end

function GM:IsValidSpectator( pl )

	if ( !IsValid( pl ) ) then return false end
	if ( pl:Team() != TEAM_SPECTATOR && !pl:IsObserver() ) then return false end
	
	return true

end

function GM:IsValidSpectatorTarget( pl, ent )

	if ( !IsValid( ent ) ) then return false end
	if ( ent == pl ) then return false end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorEntityNames( pl ), ent:GetClass() ) ) then return false end
	if ( !ent:IsPlayer()) then return false end
	if ( !ent:Alive() ) then return false end
	if ( ent:IsObserver() ) then return false end
	if ( GAMEMODE.CanOnlySpectateOwnTeam:GetInt() && pl:Team() != ent:Team() && pl:Team() != TEAM_SPECTATOR) then return false end
	
	return true

end

function GM:GetSpectatorTargets( pl )

	local t = {}
	for k, v in pairs( GAMEMODE:GetValidSpectatorEntityNames( pl ) ) do
		t = table.Merge( t, ents.FindByClass( v ) )
	end
	
	return t

end

function GM:FindRandomSpectatorTarget( pl )

	local Targets = GAMEMODE:GetSpectatorTargets( pl )
	return table.Random( Targets )

end

function GM:FindNextSpectatorTarget( pl, ent )

	local Targets = GAMEMODE:GetSpectatorTargets( pl )
	return table.FindNext( Targets, ent )

end

function GM:FindPrevSpectatorTarget( pl, ent )

	local Targets = GAMEMODE:GetSpectatorTargets( pl )
	return table.FindPrev( Targets, ent )

end

function GM:StartEntitySpectate( pl )

	local CurrentSpectateEntity = pl:GetObserverTarget()
	
	for i=1, 32 do
	
		if ( GAMEMODE:IsValidSpectatorTarget( pl, CurrentSpectateEntity ) ) then
			pl:SpectateEntity( CurrentSpectateEntity )
			return
		end
	
		CurrentSpectateEntity = GAMEMODE:FindRandomSpectatorTarget( pl )
	
	end

end

function GM:NextEntitySpectate( pl )

	local Target = pl:GetObserverTarget()
	
	for i=1, 32 do
	
		Target = GAMEMODE:FindNextSpectatorTarget( pl, Target )	
		
		if ( GAMEMODE:IsValidSpectatorTarget( pl, Target ) ) then
			pl:SpectateEntity( Target )
			return
		end
	
	end

end

function GM:PrevEntitySpectate( pl )

	local Target = pl:GetObserverTarget()
	
	for i=1, 32 do
	
		Target = GAMEMODE:FindPrevSpectatorTarget( pl, Target )	
		
		if ( GAMEMODE:IsValidSpectatorTarget( pl, Target ) ) then
			pl:SpectateEntity( Target )
			return
		end
	
	end

end

function GM:ChangeObserverMode( pl, mode )

	if ( pl:GetInfoNum( "cl_spec_mode", 0) != mode ) then
		pl:ConCommand( "cl_spec_mode "..mode )
	end

	if ( mode == OBS_MODE_IN_EYE || mode == OBS_MODE_CHASE ) then
		GAMEMODE:StartEntitySpectate( pl, mode )
	end
	
	pl:SpectateEntity( NULL )
	pl:Spectate( mode )

end

function GM:BecomeObserver( pl )

	local mode = pl:GetInfoNum( "cl_spec_mode", OBS_MODE_CHASE )
	
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( pl ), mode ) ) then 
		mode = table.FindNext( GAMEMODE:GetValidSpectatorModes( pl ), mode )
	end
	
	GAMEMODE:ChangeObserverMode( pl, mode )

end

local function spec_mode( pl, cmd, args )

	if ( !GAMEMODE:IsValidSpectator( pl ) ) then return end
	
	local mode = pl:GetObserverMode()
	local nextmode = table.FindNext( GAMEMODE:GetValidSpectatorModes( pl ), mode )
	
	GAMEMODE:ChangeObserverMode( pl, nextmode )

end

concommand.Add( "spec_mode",  spec_mode )

local function spec_next( pl, cmd, args )

	if ( !GAMEMODE:IsValidSpectator( pl ) ) then return end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( pl ), pl:GetObserverMode() ) ) then return end
	
	GAMEMODE:NextEntitySpectate( pl )

end

concommand.Add( "spec_next",  spec_next )

local function spec_prev( pl, cmd, args )

	if ( !GAMEMODE:IsValidSpectator( pl ) ) then return end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( pl ), pl:GetObserverMode() ) ) then return end
	
	GAMEMODE:PrevEntitySpectate( pl )

end

concommand.Add( "spec_prev",  spec_prev )