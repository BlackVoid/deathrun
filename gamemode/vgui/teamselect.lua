local PANEL = {};

function PANEL:Init()
	self:SetSize(500,500)
	self:Center()
	self:MakePopup()
	self.startTime = SysTime()

	self.Play = vgui.Create("FTeamBtn", self)
	self.Play:SetText("Play")
	self.Play:SetPos(60, 445)
	self.Play.DoClick = function (self)
		net.Start("DeathRun_SelectTeam")
		net.WriteInt(1, 4)
		net.SendToServer()
		self:GetParent():Remove()
	end

	self.Spectate = vgui.Create("FTeamBtn", self)
	self.Spectate:SetText("Spectate")
	self.Spectate:SetPos(290, 445)
	self.Spectate.DoClick = function (self)
		net.Start("DeathRun_SelectTeam")
		net.WriteInt(2, 4)
		net.SendToServer()
		self:GetParent():Remove()
	end
end

function PANEL:Paint()
	Derma_DrawBackgroundBlur( self, self.startTime )
	-- Menu HUD
	draw.RoundedBox(16, 0, 0, 500, 500, Color(0,0,0,200))
	draw.SimpleTextOutlined("DeathRun", "DR_Header", 250, 36, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))

	-- Text
	draw.DrawText(GAMEMODE.MOTD, "DR_Body", 10, 80, Color(255,255,255,255), TEXT_ALIGN_LEFT)

	-- Credits
	draw.DrawText("By BlackVoid", "DR_Body", 410, 65, Color(255,255,255,255), TEXT_ALIGN_LEFT)
end
vgui.Register( "FTeamSelect", PANEL, "Panel" );

local PANEL = {}
function PANEL:Init()
	self:SetSize(150, 40)
	self.Hover = false;
	self.DoClick = function() end
	self.Text = "My button";
	self.HoverColor = Color(255,255,255,255)
	self.Color = Color(220,220,220,255)
end

function PANEL:OnCursorEntered()
	self.Hover = true;
end

function PANEL:OnCursorExited()
	self.Hover = false;
end

function PANEL:OnMouseReleased()
	self:DoClick();
end

function PANEL:SetText( str )
	self.Text = str;
end

function PANEL:Paint()
	draw.SimpleTextOutlined(self.Text, "DR_BtnText", self:GetWide()/2, self:GetTall()/2, self.Hover and self.HoverColor or self.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))	
end
vgui.Register( "FTeamBtn", PANEL, "Panel" );