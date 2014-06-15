GAMEMODE.TouchEvents:Setup(Vector(9213,9729,-2176), Vector(7168,10752,-2135), function(ply)
	if ply:Team() == TEAM_RUN then
		ply:SetPos(Vector(7054,10236,-2040))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end)