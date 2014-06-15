DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

PLAYER.WalkSpeed 			= 275
PLAYER.RunSpeed				= 275
PLAYER.Model				= ""
PLAYER.JumpPower			= 210
PLAYER.DropWeaponOnDie 		= false
PLAYER.TeammateNoCollide	= true

function PLAYER:Spawn()
	--
end

function PLAYER:SetModel()
	self.Player:SetModel("models/player/Group01/male_07.mdl")
end

function PLAYER:Loadout()
	self.Player:RemoveAllAmmo()
	self.Player:StripWeapons()

	self.Player:Give( "weapon_crowbar" )
end

player_manager.RegisterClass( "runner", PLAYER, "player_default" )