function GM:NumAliveInTeam(tm)
	local alive = 0
	for k,v in pairs(team.GetPlayers(tm)) do
		alive = alive + (v:Alive() and 1 or 0)
	end
	return alive
end

function GM:GetActivePlayers()
	return table.Add(team.GetPlayers( TEAM_RUN ), team.GetPlayers( TEAM_DEATH ))
end

function GM:VecDistance(Vec1, Vec2)
	return math.sqrt((Vec1.x-Vec2.x)^2+(Vec1.y-Vec2.y)^2+(Vec1.z-Vec2.z)^2)
end

function GM:FormatNumber(amount)
	local formatted = amount
	if formatted == nil then return "0" end
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
		if (k==0) then
			break
		end
	end
	return formatted
end