GM.Round = 0

function GM:GetRound()
	return self.Round
end

if SERVER then
	util.AddNetworkString( "DeathRun_Round" )
	
	function GM:SetRound(num)
		self.Round = num
		net.Start("DeathRun_Round")
		net.WriteInt(num, 8)
		net.Broadcast()
	end

	function GM:NextRound()
		self:SetRound(self.Round + 1)
	end
else
	function GM.ReceiveRoundResult( length )
		local winner = net.ReadInt(4)
		if winner == TEAM_RUN then
			surface.PlaySound("music/HL2_song15.mp3")
		else
			surface.PlaySound("music/stingers/HL1_stinger_song8.mp3")
		end
		GAMEMODE.Winner = winner

		hook.Call("OnRoundEnd", GAMEMODE, winner)
	end
	net.Receive("DeathRun_RoundResult", GM.ReceiveRoundResult)

	-- If player joins during gamestate STATE_ROUND_OVER he/she will see the winner
	function GM.LastWinner( length )
		GAMEMODE.Winner = net.ReadInt(4)
	end
	net.Receive("DeathRun_LastWinner", GM.LastWinner)

	function GM.ReceiveRound(len)
		GAMEMODE.Round = net.ReadInt(8)
	end
	net.Receive("DeathRun_Round", GM.ReceiveRound)

	function GM.NetRoundStart(len)
		hook.Call("OnRoundStart", GAMEMODE, net.ReadInt(8))
	end
	net.Receive("DeathRun_RoundStart", GM.NetRoundStart)
end