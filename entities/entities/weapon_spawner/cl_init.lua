include('shared.lua')

local FullRotationTime = 10

function ENT:Think()
	
	self.Entity:SetAngles(self.Entity:GetAngles() + Angle(0,FrameTime()/FullRotationTime*360,0))
	
end
