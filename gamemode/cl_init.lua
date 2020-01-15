include("shared.lua")
include("sh_playermeta.lua")
include("sh_round.lua")
include("sh_gamestate.lua")
include("cl_round.lua")
include("cl_claim.lua")
include("sh_util.lua")
include("cl_targetid.lua")
include("cl_scoreboard.lua")

include("classes/death.lua")
include("classes/runner.lua")

include("vgui/fonts.lua")
include("vgui/polygenerator.lua")
include("vgui/fhud.lua")
include("vgui/teamselect.lua")
include("vgui/pingbars.lua")

-- Open Team Selection menu when initialized.
if GM.TeamSelect then GM.TeamSelect:Remove() end
GM.TeamSelect = vgui.Create("FTeamSelect")

-- ClientConVar for spectator modes.
CreateClientConVar( "cl_spec_mode", "5", true, true )

-- Runs paint functions
function GM:HUDPaint()
    hook.Run( "HUDDrawTargetID" )
    hook.Run( "HUDDrawButtons" )
end

-- Spectator binds
function GM:PlayerBindPress( pl, bind, down )
	if pl:IsObserver() && down then
		if bind == "+jump" then
			RunConsoleCommand( "spec_mode" )
			return true
		end
		if bind == "+attack" then
			RunConsoleCommand("spec_next")
			return true
		end
		if bind == "+attack2" then
			RunConsoleCommand("spec_prev")
			return true
		end
	end
end

-- Open Team Select menu.
net.Receive("DeathRun_OpenSelectTeamMenu", function (length)
	if GAMEMODE.TeamSelect then GAMEMODE.TeamSelect:Remove() end
	GAMEMODE.TeamSelect = vgui.Create("FTeamSelect")
end)

-- Make gmod draw hands on viewmodel
function GM:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end