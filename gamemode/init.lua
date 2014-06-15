resource.AddFile("materials/deathrun/skull.png")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_round.lua")
AddCSLuaFile("cl_claim.lua")
AddCSLuaFile("sh_round.lua")
AddCSLuaFile("sh_gamestate.lua")
AddCSLuaFile("sh_util.lua")
AddCSLuaFile("sh_playermeta.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("cl_scoreboard.lua")

AddCSLuaFile("vgui/fonts.lua")
AddCSLuaFile("vgui/polygenerator.lua")
AddCSLuaFile("vgui/fhud.lua")
AddCSLuaFile("vgui/teamselect.lua")
AddCSLuaFile("vgui/pingbars.lua")

include("shared.lua")
include("sh_playermeta.lua")
include("classes/death.lua")
include("classes/runner.lua")
include("classes/runner.lua")
include("sh_util.lua")
include("sv_round.lua")
include("sh_round.lua")
include("sh_gamestate.lua")
include("sv_spectator.lua")
include("sv_player.lua")
include("sv_touchevents.lua")
include("sv_claim.lua")

util.AddNetworkString( "DeathRun_SelectTeam" )
util.AddNetworkString( "DeathRun_OpenSelectTeamMenu" )

GM.Sounds = {}
GM.Sounds.CitizenDeath = {
	"vo/npc/Barney/ba_ohshit03.wav",
	"vo/npc/Barney/ba_no01.wav",
	"vo/npc/Barney/ba_no02.wav",
	"vo/npc/male01/no01.wav",
	"vo/npc/male01/no02.wav",
}

GM.Sounds.CombineDeath = {
	"npc/combine_soldier/die1.wav",
	"npc/combine_soldier/die2.wav",
	"npc/combine_soldier/die3.wav",
	"npc/overwatch/radiovoice/die1.wav",
	"npc/overwatch/radiovoice/die2.wav",
	"npc/overwatch/radiovoice/die3.wav",
}

function GM:PostCleanupMap()
    self:LoadButtons()
end

function GM:Think()
	self:ButtonThink()
end

function GM:InitPostEntity()
	RunConsoleCommand("sv_airaccelerate", "800")
	RunConsoleCommand("sv_accelerate", "8")
	RunConsoleCommand("sv_alltalk", "1")
	RunConsoleCommand("sv_kickerrornum", "0")
	RunConsoleCommand("sv_sticktoground", "0")

	if file.Exists("gamemodes/" .. string.lower( GAMEMODE.Name ) .. "/gamemode/maps/" .. string.lower( game.GetMap() ) .. ".lua", "GAME") then
		include("../gamemodes/" .. string.lower( GAMEMODE.Name ) .. "/gamemode/maps/" .. string.lower( game.GetMap() ) .. ".lua")
	end 
end