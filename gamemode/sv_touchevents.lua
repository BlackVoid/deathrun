-- Modified from STBase available at http://facepunch.com/showthread.php?t=1280533 released under Creative Commons Attribution 3.0 Unported.
-- Full terms at http://creativecommons.org/licenses/by/3.0/deed.en_US


GM.TouchEvents = {}
GM.TouchEvents.Entitys = {}

function GM.TouchEvents:Setup(...)
	arg = {...}
	if #arg < 3 then Msg("Invalid TouchEvent arguments!\n") return end
	
	if type(arg[2]) == "number" then -- sphere
	
		local pos, radius, func = arg[1], arg[2], arg[3]
		if(self.Entitys[pos] and IsValid(self.Entitys[pos].Ent)) then
			self.Entitys[pos].Ent:Remove()
		end
		self.Entitys[pos] = {Radius = radius, Function = func}
		
	elseif type(arg[2]) == "Vector" then -- box
	
		local min, max, func = arg[1], arg[2], arg[3]
		if(self.Entitys[min] and IsValid(self.Entitys[min].Ent)) then
			self.Entitys[min].Ent:Remove()
		end
		self.Entitys[min] = {Max = max, Function = func}
		
	else
		Msg("Invalid TouchEvent setup!\n")
	end
end

function GM.TouchEvents:Create(Pos, Table)
	local Ent = ents.Create("dr_touchevent")
	Ent:SetPos(Pos)
	
	if Table.Radius then -- sphere
		Ent:SetupSphere(Table.Radius, Table.Function)
	elseif Table.Max then -- box
		Ent:SetupBox(Pos, Table.Max, Table.Function)
	end
	
	Ent:Spawn()
	Ent:Activate()
	return Ent
end

function GM.TouchEvents:Check(Pos, Table)
	if(!IsValid(Table.Ent)) then
		Table.Ent = self:Create(Pos, Table)
	end
	return Table
end

function GM.TouchEvents:CheckAll()
	for k,v in pairs(self.Entitys) do
		self.Entitys[k] = self:Check(k, v)
	end
end

function GM.TouchEvents:RemoveAll()
	for k,v in pairs(self.Entitys) do
		if(IsValid(v.Ent)) then
			v.Ent:Remove()
		end
	end
end