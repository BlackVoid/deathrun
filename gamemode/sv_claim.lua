util.AddNetworkString( "DeathRun_UpdateButtons" )

--[[
	subtable:
	{
		entityID = EntityID
		owner = Player
	}
]]
GM.MapButtons = {}
GM.TableMap = {}
GM.NextButtonThink = 0


function GM:LoadButtons()
	self.MapButtons = {}
	self.TableMap = {}
	local id
	for k,v in pairs(ents.FindByClass('func_button')) do
		id = #self.MapButtons + 1
		self.MapButtons[id] = {entityID = v:EntIndex(), owner = nil}
		self.TableMap[v:EntIndex{}] = id
	end
	self:SyncButtons()
end

function GM:SetButtonOwnership(entID, ply)
	self.MapButtons[self.TableMap[entID]].owner = ply

	net.Start("DeathRun_UpdateButtons")
		net.WriteUInt(1,8)
		net.WriteUInt(entID,16)
		net.WriteEntity(ply)
	net.Broadcast()

	for k,v in pairs(self.MapButtons) do
		if v.entityID != entID and v.owner == ply then
			self:RemoveButtonOwnership(v.entityID)
		end
	end
end

function GM:GetButtonOwner(entID)
	return self.MapButtons[self.TableMap[entID]].owner
end

function GM:RemoveButtonOwnership(entID)
	self.MapButtons[self.TableMap[entID]].owner = nil

	net.Start("DeathRun_UpdateButtons")
		net.WriteUInt(1,8)
		net.WriteUInt(entID,16)
		net.WriteEntity(nil)
	net.Broadcast()
end

function GM:ResetButtonOwnership()
	for k,v in pairs(self.MapButtons) do
		self.MapButtons[k].owner = nil
	end
	self:SyncButtons()
end

function GM:SyncButtons()
	net.Start("DeathRun_UpdateButtons")
		net.WriteUInt(#self.MapButtons,8)
		for k,v in pairs(self.MapButtons) do
			net.WriteUInt(v.entityID,16)
			net.WriteEntity(v.owner)
		end
	net.Broadcast()
end

function GM:PlayerUse(ply, ent)
	if not ply:Alive() or not ( ply:Team() == TEAM_DEATH or ply:Team() == TEAM_RUN ) then
		return false
	end
	if ent:GetClass() == "func_button" and self.TableMap[ent:EntIndex()] and self.MapButtons[self.TableMap[ent:EntIndex()]].owner != nil then
		if self.MapButtons[self.TableMap[ent:EntIndex()]].owner != ply then
			return false
		else
			self:RemoveButtonOwnership(ent:EntIndex())			
		end
	end
	return true
end

function GM:ButtonThink()
	if CurTime() < self.NextButtonThink then return end
	for k,v in pairs(self.MapButtons) do
		if v.owner and self:VecDistance(v.owner:GetPos(), Entity(v.entityID):GetPos()) > 200 then
			self:RemoveButtonOwnership(v.entityID)
		end
	end

	self.NextButtonThink = CurTime()+0.25
end

concommand.Add("dr_claimbutton", function(ply, cmd, args)
	if not ply:Alive() or ply:Team() != TEAM_DEATH then return end

	local ent = ply:GetEyeTrace().Entity
	local distance = GAMEMODE:VecDistance(ply:GetPos(), ent:GetPos())
	if distance < 150 then
		if GAMEMODE:GetButtonOwner(ent:EntIndex()) == nil then
			GAMEMODE:SetButtonOwnership(ent:EntIndex(), ply)
		end
	end
end)