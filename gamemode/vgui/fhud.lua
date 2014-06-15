function GM:HUDShouldDraw(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"})do
		if name == v then return false end
	end
	return true
end

local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self.w = self:GetWide()
	self.h = self:GetTall()
	self:InvalidateLayout()
end

function PANEL:Think()
	if self.w != self:GetWide() or self.h != self:GetTall() then
		self.w = self:GetWide()
		self.h = self:GetTall()
		self:InvalidateLayout()
	end
end

function PANEL:InvalidateLayout(layoutNow)
	centerx 				= self:GetWide()/2
	centery 				= self:GetTall()/2

	self.Combine 			= PolyGen:GeneratePolyBar(centerx-250, 10, 150, 25)
	self.Citizens 			= PolyGen:GeneratePolyBarInverted(centerx+85, 10, 150, 25)
	self.TimerTop 			= PolyGen:GeneratePolyTimerTop(centerx, 10)
	self.TimerMiddle 		= PolyGen:GeneratePolyTimerMiddle(centerx, 40)
	self.TimerBottom 		= PolyGen:GeneratePolyTimerBottom(centerx, 70)

	surface.SetFont( "DermaLarge" )
	local w, h 				= surface.GetTextSize( "Waiting for players..." )
	self.WaitingBar 		= PolyGen:GeneratePolyBarTII(centerx-(w/2)-20, centery-(h/2)-15, w+20, h+10, 20)
	self.WaitingBarPlayers 	= PolyGen:GeneratePolyBarTII(centerx-(w)/4-(12.5/2), centery+(h/2)-5, (w)/2, (3*h)/4, 12.5)

	self.SpecInfo 			= PolyGen:GeneratePolyHalfBar(5, self:GetTall()-58, 238, 25)
	self.HealthInfo 		= PolyGen:GeneratePolyHalfBar(5, self:GetTall()-30, 260, 25)

	self.AmmoInfo 			= PolyGen:GeneratePolyHalfBarInverted(self:GetWide()-125, self:GetTall()-30, 120, 25)

	self.HealthBar 			= {}
	self.HealthBar[1] 		= PolyGen:GeneratePolyBarCutOffFirst(10, self:GetTall()-21, 8, 13)
	for i=2,20 do
		self.HealthBar[i] 	= PolyGen:GeneratePolyBar(10+((i-2)*15), self:GetTall()-27, 10, 19)
	end

	self.TimeBar 			= {}
	for i=1,28 do
		self.TimeBar[i] 	= PolyGen:GeneratePolyBar(centerx-225+((i-1)*15), 43, 10, 23)
	end
	self.TimeBar[29] 		= PolyGen:GeneratePolyBarCutOff(centerx-225+((29-1)*15), 43, 10, 23)
	self.TimeBar[30] 		= PolyGen:GeneratePolyBarCutOffLast(centerx-225+((30-1)*15), 43, 16, 12)

	self.BarT 				= (GM and GM or GAMEMODE).RoundLength:GetInt()/30
	self.BarH 				= 100/18
	self.CurHealth 			= 0
end

function PANEL:Paint()
	if not LocalPlayer() or not IsValid(LocalPlayer()) then return end
	draw.NoTexture()
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawPoly( self.Combine )
	surface.DrawPoly( self.Citizens )
	surface.DrawPoly( self.TimerTop )
	surface.DrawPoly( self.TimerMiddle )
	surface.DrawPoly( self.TimerBottom )

	local TimeLeft = GAMEMODE:GetGameState() == STATE_WAITING_FOR_PLAYERS and GAMEMODE.RoundLength:GetInt() or math.Clamp(GetGlobalInt("DeathRun_TimeLeft", 0), 0, GAMEMODE.RoundLength:GetInt())
	local x = math.Clamp(math.ceil((TimeLeft)/self.BarT), 0, 30)
	local y = (TimeLeft)/self.BarT

	-- Round timer bars
	for i=1, 30 do
		surface.SetDrawColor(255, 255, 255, (i>x and 10 or (i == x and (i == y and 255 or (((TimeLeft)%self.BarT)*(245/self.BarT))+10))))
		surface.DrawPoly( self.TimeBar[i] )
	end

	-- Round/Game info text
	draw.SimpleText( "Combine - " .. team.GetScore(TEAM_DEATH), "FuturisticHudScore", centerx-170, 22, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "Citizens - " .. team.GetScore(TEAM_RUN), "FuturisticHudScore", centerx+170, 22, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "Round " .. math.max(1, GAMEMODE:GetRound()) .. " of " .. GAMEMODE.RoundLimit:GetInt(), "FuturisticHudText", centerx, 22, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	draw.SimpleText( (TimeLeft<0 and "00:00" or PolyGen:FormatSeconds(TimeLeft)), "FuturisticHudTimer", centerx, 80, (TimeLeft<=60 and Color(255, 0, 0, 255) or Color(255, 255, 255, 255)) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	-- End of round text
	if GAMEMODE:GetGameState() == STATE_ROUND_OVER then
		draw.SimpleTextOutlined( team.GetName(GAMEMODE.Winner) .. "s won!", "FuturisticHudResult", self:GetWide()/2, self:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
	end

	draw.NoTexture()
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawPoly( self.AmmoInfo )

	-- Ammo text
	if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon().Clip1 and LocalPlayer():GetActiveWeapon():Clip1() >= 0 then
		local wep = LocalPlayer():GetActiveWeapon()
		draw.SimpleText( wep:Clip1() .. " / " .. LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType()), "FuturisticHudAmmo", self:GetWide()-65, self:GetTall()-18, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else
		draw.SimpleText( "- / -", "FuturisticHudAmmo", self:GetWide()-65, self:GetTall()-18, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	draw.NoTexture()
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawPoly( self.SpecInfo )
	surface.DrawPoly( self.HealthInfo )

	self.CurHealth = math.Clamp(Lerp( 0.05, self.CurHealth, ((LocalPlayer():GetObserverTarget() != nil) and LocalPlayer():GetObserverTarget():Health() or LocalPlayer():Health())), 0 , 100)

	-- Health bars
	local x = math.Clamp(math.ceil(self.CurHealth/self.BarH), 0, 18)
	local y = self.CurHealth/self.BarH
	for i=1, 18 do
		surface.SetDrawColor(255, 255, 255, (i > x and 10 or (x == i and (i == y and 255 or (((self.CurHealth)%self.BarH)*(245/self.BarH))+10))))
		surface.DrawPoly( self.HealthBar[i] )
	end

	-- Team/Player/Spectator text
	if !LocalPlayer():IsObserver() then
		draw.SimpleTextOutlined(team.GetName(LocalPlayer():Team()), "FuturisticHudText", 129, self:GetTall()-45, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
	else
		draw.SimpleTextOutlined(IsValid(LocalPlayer():GetObserverTarget()) and LocalPlayer():GetObserverTarget():Nick() or "ROAMING", "FuturisticHudText", 129, self:GetTall()-45, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
	end

	-- Waiting for players text
	if GAMEMODE:GetGameState() == STATE_WAITING_FOR_PLAYERS then
		draw.NoTexture()
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawPoly( self.WaitingBar )
		surface.DrawPoly( self.WaitingBarPlayers )

		local fade = (math.sin(CurTime()*3)*70)+115

		surface.SetFont( "DermaLarge" )
		local w, h 	= surface.GetTextSize( "Waiting for players..." )
		draw.SimpleText("Waiting for players...", "DermaLarge", self:GetWide()/2, self:GetTall()/2-10, Color(255,255,255,fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText((#team.GetPlayers( TEAM_RUN ) + #team.GetPlayers( TEAM_DEATH )) .." / ".. GAMEMODE.MinPlayers:GetInt(), "DermaLarge", self:GetWide()/2, self:GetTall()/2+(7*h)/8-5, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	-- Spectator controlls
	if LocalPlayer():IsObserver() then
		draw.SimpleTextOutlined("Left click - Previous player", "Default", self:GetWide()/2, self:GetTall()-30, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		draw.SimpleTextOutlined("Right click - Next player", "Default", self:GetWide()/2, self:GetTall()-20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		draw.SimpleTextOutlined("Space - Change perspective", "Default", self:GetWide()/2, self:GetTall()-10, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
	end
end

vgui.Register( "FHUD", PANEL, "Panel" );
if HUD then HUD:Remove() end
HUD = vgui.Create("FHUD", vgui.GetWorldPanel( ))