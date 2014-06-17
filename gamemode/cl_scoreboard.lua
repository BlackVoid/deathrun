-- Modified sandbox scoreboard

surface.CreateFont( "ScoreboardDefault",
{
	font        = "Helvetica",
	size        = 18,
	weight      = 800
})

surface.CreateFont( "ScoreboardInfo",
{
	font        = "Helvetica",
	size        = 14,
	weight      = 200
})

surface.CreateFont( "ScoreboardTeams",
{
	font        = "Helvetica",
	size        = 26,
	weight      = 800
})

surface.CreateFont( "ScoreboardSpectator",
{
	font        = "Helvetica",
	size        = 14,
	weight      = 400
})

surface.CreateFont( "ScoreboardDefaultTitle",
{
	font        = "Helvetica",
	size        = 32,
	weight      = 800
})

if g_Scoreboard then
	g_Scoreboard:Remove()
end


--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PLAYER_LINE = 
{
	Init = function( self )

		self.AvatarButton = self:Add( "DButton" )
		self.AvatarButton:Dock( LEFT )
		self.AvatarButton:SetSize( 32, 32 )
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar        = vgui.Create( "AvatarImage", self.AvatarButton )
		self.Avatar:SetSize( 32, 32 )
		self.Avatar:SetMouseInputEnabled( false )

		self.Mute        = self:Add( "DImageButton" )
		self.Mute:SetSize( 32, 32 )
		self.Mute:Dock( RIGHT )

		self.Ping        = self:Add( "PingBars")
		self.Ping:SetSize( 32, 32 )
		self.Ping:Dock( RIGHT )
		self.Ping:SetContentAlignment( 6 )
		self.Ping:DockMargin( 0, 0, 0, 0 )

		self.Dead        = self:Add( "DImage" )
		self.Dead:SetSize( 32, 32 )
		self.Dead:Dock( RIGHT )
		self.Dead:SetImage( "deathrun/skull.png" )
		self.Dead:DockMargin( 0, 0, 4, 0 )
		self.Dead:Hide()

		self.InfoPanel = self:Add( "Panel" )
		self.InfoPanel:Dock( FILL )

		self.Name        = self:Add( "DLabel", self.InfoPanel)
		self.Name:Dock( TOP )
		self.Name:SetFont( "ScoreboardDefault" )
		self.Name:DockMargin( 8, 0, 0, 0 )
		self.Name:SetColor(Color(255,255,255))

		self.Currency        = self:Add( "DLabel", self.InfoPanel)
		self.Currency:Dock( TOP )
		self.Currency:SetContentAlignment( 7 )
		self.Currency:SetFont( "ScoreboardInfo" )
		self.Currency:DockMargin( 8, -2, 0, 0 )
		self.Currency:SetColor(Color(255,255,255))

		self:Dock( TOP )
		self:DockPadding( 3, 3, 3, 3 )
		self:SetHeight( 32 + 3*2 )
		self:DockMargin( 2, 0, 2, 2 )

		self.Gradient = surface.GetTextureID("gui/gradient_down")
		self.Diag = math.sqrt(32^2+32^2)

	end,

	Setup = function( self, pl )

		self.Player = pl

		self.Avatar:SetPlayer( pl )
		self.Ping:Setup( pl )
		self.Name:SetText( pl:Nick() )

		self:Think( self )

		--local friend = self.Player:GetFriendStatus()
		--MsgN( pl, " Friend: ", friend )

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) ) then
			self:Remove()
			return
		end
		
		if ( self.NumCurrency == nil || self.NumCurrency != (self.Player.PS_Points or self.Player.ThemisShop_Coins) ) then
			self.NumCurrency = self.Player.PS_Points or self.Player.ThemisShop_Coins
			self.Currency:SetText( (Themis and "Gold: " or ((PS and PS.Config.PointsName or 'Points') .. ": ")).. GAMEMODE:FormatNumber(self.NumCurrency))
		end

		--
		-- Change the icon of the mute button based on state
		--
		if ( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

			self.Muted = self.Player:IsMuted()
			if ( self.Muted ) then
				self.Mute:SetImage( "icon32/muted.png" )
			else
				self.Mute:SetImage( "icon32/unmuted.png" )
			end

			self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

		end

		if ( self.IsDead == nil || self.IsDead != not self.Player:Alive() ) then

			self.IsDead = not self.Player:Alive()
			if ( self.IsDead ) then
				self.Dead:Show()
			else
				self.Dead:Hide()
			end

		end

		--
		-- Connecting players go at the very bottom
		--
		if ( self.Player:Team() == TEAM_CONNECTING ) then
			self:SetZPos( 2000 )
		end

		--
		-- This is what sorts the list. The panels are docked in the z order, 
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		self:SetZPos( self.Player:Alive() and -1 or 1)

	end,

	Paint = function( self, w, h )

		if ( !IsValid( self.Player ) ) then
			return
		end

		--
		-- We draw our background a different colour based on the status of the player
		--

		if ( self.Player:Team() == TEAM_CONNECTING ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 200, 200, 200, 200 ) )
			return
		end

		local col = hook.Call("DeathRun_ScoreboardBackgroundColor", GAMEMODE, self.Player) or team.GetColor(self.Player:Team())

		draw.RoundedBox( 4, 0, 0, w, h, col)

		surface.SetDrawColor( 0, 0, 0, 125 );
		surface.SetTexture( self.Gradient );
		surface.DrawTexturedRect( 0, 0, w, h);
		

	end
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" );

--
-- Here we define a new panel table for the scoreboard. It basically consists 
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD = 
{
	Init = function( self )

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 70 )

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "ScoreboardDefaultTitle" )
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )

		self.Death = self.Header:Add( "DLabel" )
		self.Death:SetFont( "ScoreboardTeams" )
		self.Death:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Death:Dock( LEFT )
		self.Death:SetHeight( 40 )
		self.Death:SetWidth( 340 )
		self.Death:SetContentAlignment( 2 )
		self.Death:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		self.Death:SetText(GAMEMODE.DeathP)

		self.Runners = self.Header:Add( "DLabel" )
		self.Runners:SetFont( "ScoreboardTeams" )
		self.Runners:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Runners:Dock( RIGHT )
		self.Runners:SetHeight( 40 )
		self.Runners:SetWidth( 340 )
		self.Runners:SetContentAlignment( 5 )
		self.Runners:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		self.Runners:SetText(GAMEMODE.RunnerP)

		--self.NumPlayers = self.Header:Add( "DLabel" )
		--self.NumPlayers:SetFont( "ScoreboardDefault" )
		--self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
		--self.NumPlayers:SetPos( 0, 100 - 30 )
		--self.NumPlayers:SetSize( 300, 30 )
		--self.NumPlayers:SetContentAlignment( 4 )

		self.Footer = self:Add( "Panel" )
		self.Footer:Dock( BOTTOM )
		self.Footer:SetHeight( 30 )

		self.SpectatorLabel = self.Footer:Add( "DLabel" )
		self.SpectatorLabel:SetFont( "ScoreboardSpectator" )
		self.SpectatorLabel:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.SpectatorLabel:Dock( BOTTOM )
		self.SpectatorLabel:SetHeight( 20 )
		self.SpectatorLabel:SetContentAlignment( 5 )
		self.SpectatorLabel:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )

		self.Death = self:Add( "DScrollPanel" )
		self.Death:Dock( LEFT )
		self.Death:SetWidth(340)

		self.Runners = self:Add( "DScrollPanel" )
		self.Runners:Dock( RIGHT )
		self.Runners:SetWidth(340)


	end,

	PerformLayout = function( self )

		self:SetSize( 700, ScrH() - 300 )
		self:SetPos( ScrW() / 2 - 350, 150 )

	end,

	Paint = function( self, w, h )

		--draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

	end,

	Think = function( self, w, h )

		self.Name:SetText( GetHostName() )
		local spec = ""
		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		for id, pl in pairs( plyrs ) do

			if ( IsValid( pl.DeathScoreEntry ) ) and pl:Team() != TEAM_DEATH then
				pl.DeathScoreEntry:Remove()
				pl.DeathScoreEntry:PerformLayout()
				pl.DeathScoreEntry:InvalidateParent()
			end
			if ( IsValid( pl.RunnerScoreEntry ) ) and pl:Team() != TEAM_RUN then
				pl.RunnerScoreEntry:Remove()
				pl.RunnerScoreEntry:PerformLayout()
				pl.RunnerScoreEntry:InvalidateParent()
			end
			if pl:Team() != TEAM_RUN and pl:Team() != TEAM_DEATH then
				spec = spec .. (#spec == 0 and "" or ", ")  .. pl:Nick()
				continue
			end
			if ( IsValid( pl.DeathScoreEntry ) or IsValid( pl.RunnerScoreEntry ) ) then continue end

			if pl:Team() == TEAM_RUN then
				pl.RunnerScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.RunnerScoreEntry )
				pl.RunnerScoreEntry:Setup( pl )
				self.Runners:AddItem( pl.RunnerScoreEntry )
			else    
				pl.DeathScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.DeathScoreEntry )
				pl.DeathScoreEntry:Setup( pl )
				self.Death:AddItem( pl.DeathScoreEntry )
			end

		end
		self.SpectatorLabel:SetText("Spectators: " .. spec)     

	end,
}

SCORE_BOARD = vgui.RegisterTable( SCORE_BOARD, "EditablePanel" );

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

	if ( !IsValid( g_Scoreboard ) ) then
		g_Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
	end

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Show()
		g_Scoreboard:MakePopup()
		g_Scoreboard:SetKeyboardInputEnabled( false )
	end

end

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Hide()
	end

end


--[[---------------------------------------------------------
   Name: gamemode:HUDDrawScoreBoard( )
   Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()

end
