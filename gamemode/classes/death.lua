DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

PLAYER.WalkSpeed 			= 300
PLAYER.RunSpeed				= 425
PLAYER.Model				= ""
PLAYER.JumpPower			= 210
PLAYER.DropWeaponOnDie 		= false
PLAYER.TeammateNoCollide	= true

function PLAYER:Spawn()
	--
end

function PLAYER:SetModel()
	self.Player:SetModel("models/player/police.mdl")
end

function PLAYER:Loadout()
	self.Player:RemoveAllAmmo()
	self.Player:StripWeapons()

	self.Player:Give( "weapon_crowbar" )
end

player_manager.RegisterClass( "death", PLAYER, "player_default" )