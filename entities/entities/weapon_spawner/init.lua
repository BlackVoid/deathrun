AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Model = "models/weapons/w_smg1.mdl"
ENT.Weapon = "weapon_smg1"
ENT.AmmoType = "smg1"
ENT.Ammo = 10000

function ENT:Initialize()
	self.Entity:SetModel( self.Model )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetAngles( Angle(0,0,0) )
	self.Entity:SetPos( self.Entity:GetPos() + Vector(0,0,10) ) --move a bit up to make sure it's not in the ground
end

function ENT:Think()
	for _,ply in pairs(ents.FindInSphere( self.Entity:GetPos(), self.Entity:BoundingRadius() )) do
		if ply:IsValid() and ply:IsPlayer() and ply:Alive() and ( ply:Team() == TEAM_DEATH or ply:Team() == TEAM_RUN ) then
			if not ply:HasWeapon("weapon_crowbar") then
				ply:Give("weapon_crowbar")
			end
			if not ply:HasWeapon(self.Weapon) then
				ply:SetActiveWeapon(ply:Give(self.Weapon))
			end
			ply:SetAmmo(self.Ammo,self.AmmoType)
		end
	end
end
