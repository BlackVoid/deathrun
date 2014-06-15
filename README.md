# Deathrun

Deathrun is a gamemode made for Garry's Mod 13 developed by BlackVoid.

In this gamemode, there are 2 teams; Citizens and Combine. Citizens should
avoid the deadly traps on their way to the end, where they confront Combine. Combine
however, will try to stop Citizens by triggerings all sorts of deadliness, killing The
Citizens before they can reach the end.

Feel free to modify and send pull requests.

## 1. Convars:

    dr_round_limit (default: 10) - Total rounds per map
    dr_round_length (default: 420) - Round length in seconds.
    dr_round_post_end (default: 10) - Seconds between round end and round start.
    dr_round_pre_start (default: 1) - Seconds between spawn and round start.
    dr_initial_spawn_length (default: 30) - Seconds a player can spawn after round start (if no one has died).
    dr_minimum_players (default: 2) - Minimum players for the game to start.
    dr_player_to_death_ratio (default: 8) - Ratio between death and player count.
    dr_realistic_fall_damage (default: 1) - Damage based on speed.
    dr_spectate_own_team_only (default: 1) - If 0 both teams can spectate each other.
    dr_currency_per_round (default: 75) - How much currency each player on the winning team gets.
    dr_currency_per_kill (default: 20) - How much currency a player gets per kill with a weapon.

## 2. Hooks:

**Clientside:**

    -- Background of specified player's row.
    function GM:DeathRun_ScoreboardBackgroundColor(ply)
   		return Color(0,0,0)
    end

**Shared:**
    
    -- Called when round stars.
    function GM:OnRoundStart(round) end
    -- Called when round ends.
    function GM:OnRoundEnd(winningTeam) end

**Serverside:**
    
    -- Called when players are spawning.
    function GM:OnPreRoundStart(round) end

    -- Called when gamemode checks if a round can start or not.
    -- Hook exists, but should not be used.
    -- Return if round can be started or not.
    function GM:CanStartRound()
        return true or false
    end

    -- Called to start map vote
    -- Return if mapvote creation was successful
    function GM:StartMapVote()
        return true or false
    end

    -- Called when next map should be loaded
    -- Return next map as string excluding ".bsp"
    function GM:MapVoteNext()
        return "deathrun_atomic_warfare"
    end

## 3. License
Deathrun has been released under the MIT Open Source license.  All contributors agree to transfer ownership of their code to Felix Gustavsson for release under this license.

### 3.1 The MIT License

Copyright (C) 2014 Felix Gustavsson and contributors.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
