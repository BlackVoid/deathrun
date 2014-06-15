--[[
	1 = Waiting for players
	2 = Round in progress
	3 = Round over
]]

STATE_WAITING_FOR_PLAYERS = 1
STATE_ROUND_IN_PROGRESS = 2
STATE_ROUND_OVER = 3

GM.GameState = GM.GameState or STATE_WAITING_FOR_PLAYERS

function GM:GetGameState()
	return self.GameState
end

if SERVER then
	util.AddNetworkString( "DeathRun_GameState" )
	
	function GM:SetGameState(num)
		self.GameState = num
		net.Start("DeathRun_GameState")
		net.WriteInt(num, 4)
		net.Broadcast()
	end
else
	function GM.ReceiveGameState(len)
		GAMEMODE.GameState = net.ReadInt(4)
	end
	net.Receive("DeathRun_GameState", GM.ReceiveGameState)
end