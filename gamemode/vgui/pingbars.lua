local PANEL = {};

function PANEL:Init()
	self.NumBars = 4
	self.FillBars = 4
	self.BarColors = {
						Color(230,0,0),
						Color(255,128,0),
						Color(20,220,20),
						Color(20,200,20)
					}
end

function PANEL:Setup( ply )
	self.Player = ply

	self:Think( self )
end

function PANEL:Think( )
	if ( !IsValid( self.Player ) ) then
		return
	end
	if ( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
		self.NumPing   = self.Player:Ping()
		if self.NumPing < 50 then
			self.FillBars = 4
		elseif self.NumPing < 150 then
			self.FillBars = 3
		elseif self.NumPing < 300 then
			self.FillBars = 2
		else
			self.FillBars = 1
		end
		self.FillColor = self.BarColors[self.FillBars]
	end
end

function PANEL:Paint( w, h )
	if ( !IsValid( self.Player ) ) then
		return
	end

	-- Drawing bar border
	for i=1, self.NumBars do
		draw.RoundedBox( 0, (w/self.NumBars)*(i-1),(h/self.NumBars)*(self.NumBars-i), (w/self.NumBars)-1, (h/self.NumBars)*i+1, Color(0,0,0,255))
	end

	-- Drawing bar
	for i=1, self.FillBars do
		draw.RoundedBox( 0, (w/self.NumBars)*(i-1)+1,(h/self.NumBars)*(self.NumBars-i)-1, (w/self.NumBars)-2, (h/self.NumBars)*i, self.FillColor)
	end
	
end

vgui.Register( "PingBars", PANEL, "Panel" );