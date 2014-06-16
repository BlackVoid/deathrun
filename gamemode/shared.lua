-- Don't change the Name, author, email or website.
GM.Name 	= "Deathrun"
GM.Author 	= "BlackVoid"
GM.Email 	= "blackvoid@fantas.in"
GM.Website 	= "https://www.fantas.in/"

GM.Debug = CreateConVar("dr_debug", 0, FCVAR_REPLICATED, "Puts the gamemode in debug mode.")

GM.RoundLimit = CreateConVar("dr_round_limit", 10, FCVAR_REPLICATED, "Total rounds per map.")
GM.RoundLength = CreateConVar("dr_round_length", 60*7, FCVAR_REPLICATED, "Round length in seconds.")
GM.RoundPostEndTime = CreateConVar("dr_round_post_end", 10, FCVAR_REPLICATED, "Seconds between round end and round start.")
GM.RoundPreStartTime = CreateConVar("dr_round_pre_start", 1, FCVAR_REPLICATED, "Seconds between spawn and round start.")
GM.InitSpawnLength = CreateConVar("dr_initial_spawn_length", 30, FCVAR_REPLICATED, "Seconds a player can spawn after round start.")

GM.MinPlayers = CreateConVar("dr_minimum_players", 2, FCVAR_REPLICATED, "Minimum players for the game to start.")
GM.PlayerToDeathRatio = CreateConVar("dr_player_to_death_ratio", 8, FCVAR_REPLICATED, "Ratio between death and player count.")

GM.RealisticFallDamage = CreateConVar("dr_realistic_fall_damage", 1, FCVAR_REPLICATED, "Damage based on speed.")
GM.CanOnlySpectateOwnTeam = CreateConVar("dr_spectate_own_team_only", 1, FCVAR_REPLICATED, "If 0 both teams can spectate each other.")

GM.CoinsPerRound = CreateConVar("dr_currency_per_round", 75, FCVAR_REPLICATED, "How much currency each player on the winning team gets.")
GM.CoinsPerKill = CreateConVar("dr_currency_per_kill", 20, FCVAR_REPLICATED, "How much currency a player gets per kill with a weapon.")

GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING } -- Spectator states
GM.ValidSpectatorEntities = { "player" } -- Which entities can be spectated

GM.MOTD = [[
In this gamemode, there are 2 teams; Citizens and Combine. Citizens should
avoid the deadly traps on their way to the end, where they confront Combine. Combine
however, will try to stop Citizens by triggerings all sorts of deadliness, killing The
Citizens before they can reach the end.

Welcome, to DeathRun

Rules:
#1 Do not trapsteal
#2 Do not micspam
#3 No cheating
#4 Be nice to people
#5 Have fun
#6 No freeruns
#7 Only write and talk in english
#8 No ghosting
#9 Do not avoid being a combine
]]

-- No touching below
function GM:CreateTeams( )
	TEAM_RUN 	= 1
	TEAM_DEATH 	= 2

	-- Alias
	TEAM_RUNNER = TEAM_RUN

	team.SetUp( TEAM_RUN, "Citizen", Color( 20, 20, 200 ), true )
	team.SetSpawnPoint( TEAM_RUN, "info_player_counterterrorist" )
	team.SetClass( TEAM_RUN, { "runner" } )

	team.SetUp( TEAM_DEATH, "Combine", Color( 170, 20, 20 ), false )
	team.SetSpawnPoint( TEAM_DEATH, "info_player_terrorist" ) 
	team.SetClass( TEAM_DEATH, { "death" } )
end

weapons.Register({Base = "dr_secret"}, "weapon_knife", false)
weapons.Register({Base = "dr_secret"}, "weapon_smokegrenade", false)
weapons.Register({Base = "dr_secret"}, "weapon_flashbang", false)

GM.ReverseModelList = {}
for k,v in pairs(player_manager:AllValidModels()) do
	GM.ReverseModelList[v] = k
end