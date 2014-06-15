if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Secret"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "BlackVoid"
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModel = Model("models/weapons/v_hands.mdl")

SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	return true
end

function SWEP:Reload()
	return true
end

-- Prevent secrets from moving
function SWEP:AcceptInput( name, activator, caller, data )
	if ( name == "ConstraintBroken" && self:HasSpawnFlags( 1 ) ) then
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:EnableMotion( false ) end
	
		local newflags = bit.band( self:GetSpawnFlags(), bit.bnot( 1 ) )
		self:SetKeyValue( "spawnflags", newflags )

		self:SetNoDraw(true)
	end
end