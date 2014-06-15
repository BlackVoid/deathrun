GAMEMODE.TouchEvents:Setup(Vector(105, 1535, 320), Vector(373, 1524, 376), function(ply)
	if ply:Team() == TEAM_RUN then
		ply:SetPos(Vector(594, 1544, 193))
		ply:SetEyeAngles(Angle(0, -90, 0))
	else
		ply:SetPos(Vector(207, 1034, 193))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)

GAMEMODE.TouchEvents:Setup(Vector(373, 1524, 320), Vector(383, 383, 447), function(ply)
	if ply:Team() == TEAM_RUN then
		ply:SetPos(Vector(594, 1544, 193))
		ply:SetEyeAngles(Angle(0, -90, 0))
	else
		ply:SetPos(Vector(207, 1034, 193))
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
end)