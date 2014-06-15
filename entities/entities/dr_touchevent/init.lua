-- Modified from STBase available at http://facepunch.com/showthread.php?t=1280533 released under Creative Commons Attribution 3.0 Unported.
-- Full terms at http://creativecommons.org/licenses/by/3.0/deed.en_US

AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
end

function ENT:SetupSphere(Radius, Function)

	self.Entity:SetMoveType(MOVETYPE_NONE)
	-- self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self.Entity:SetColor(255, 255, 255, 0)

	self.Radius = Radius
	
	local RVec = Vector() * Radius
	
	self.Entity:PhysicsInitSphere(Radius)
	self.Entity:SetCollisionBounds(RVec * -1, RVec)
	
	self.Entity:SetTrigger(true)
	self.Entity:DrawShadow(false)
	self.Entity:SetNotSolid(true)
	self.Entity:SetNoDraw(true)
	
	self.Phys = self.Entity:GetPhysicsObject()
	if(self.Phys and self.Phys:IsValid()) then
		self.Phys:Sleep()
		self.Phys:EnableCollisions(false)
	end
	
	self:SetOnTouch(Function)
end

function ENT:SetupBox(Min, Max, Function)

	self.Entity:SetMoveType(MOVETYPE_NONE)
	-- self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self.Entity:SetColor(255, 255, 255, 0)
	
	local bbox = (Max - Min) / 2 -- determine actual boundaries from world vectors
	self.Entity:SetPos(self.Entity:GetPos() + bbox) -- set pos to midpoint of bbox
	
	self.Entity:PhysicsInitBox(-bbox, bbox)
	self.Entity:SetCollisionBounds(-bbox, bbox)
	
	self.Entity:SetTrigger(true)
	self.Entity:DrawShadow(false)
	self.Entity:SetNotSolid(true)
	self.Entity:SetNoDraw(true)
	
	self.Phys = self.Entity:GetPhysicsObject()
	if(self.Phys and self.Phys:IsValid()) then
		self.Phys:Sleep()
		self.Phys:EnableCollisions(false)
	end
	
	self:SetOnTouch(Function)
end

function ENT:SetOnTouch(Function)
	self.OnTouch = Function
end

function ENT:StartTouch(Ent)
	if(!Ent or !Ent:IsValid() or !Ent:IsPlayer() or !Ent:Alive()) then
		return
	end
	if(self.OnTouch) then
		local Work, Err = pcall(self.OnTouch, Ent)
		if(!Work) then
			ErrorNoHalt("TouchEvent Error: "..tostring(Err).."\n")
		end
	end
end
