local meta = FindMetaTable( "Player" )

function meta:IsObserver()
	return ( self:Team() == TEAM_SPECTATOR or self:GetObserverMode() > OBS_MODE_NONE );
end

if CLIENT then return end

function meta:DeathrunSync()
	net.Start("DeathRun_GameState")
	net.WriteInt(GAMEMODE:GetGameState(), 4)
	net.Send(self)

	net.Start("DeathRun_Round")
	net.WriteInt(GAMEMODE:GetRound(), 8)
	net.Send(self)

	net.Start("DeathRun_LastWinner")
	net.WriteInt(GAMEMODE.LastWinner, 4)
	net.Send(self)
end