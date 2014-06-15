-- HUD showing player health and name if player is near and visible.
function GM:HUDDrawTargetID()
	for k,v in pairs(self:GetActivePlayers()) do
		if v == LocalPlayer() then continue end
		local distance = self:VecDistance(LocalPlayer():GetPos(), v:GetPos())
		if v:Alive() and distance < 600 then
			local bone = v:LookupBone("ValveBiped.Bip01_Head1")
			if type(bone) != "number" then continue end
			local vec, ang = v:GetBonePosition(bone)

			local tracedata = {}
			tracedata.start = LocalPlayer():GetShootPos()
			tracedata.endpos = vec
			tracedata.filter = LocalPlayer()

			local trace = util.TraceLine(tracedata)
			if !trace.HitNonWorld or trace.Entity != v then continue end

			local text = v:Nick()
			local font = "DR_HudTargetID"

			surface.SetFont( font )
			local w, h = surface.GetTextSize( text )
			
			vec:Add(Vector(0,0,20))
			local TC = vec:ToScreen()
			local x = TC.x
			local y = TC.y

			local alpha = 255
			if distance > 345 then
				alpha = 255-(distance-345)
			end

			draw.SimpleTextOutlined( text, font, x, y-3, Color(255,255,255,alpha), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER, 1, Color(0,0,0,alpha))
			draw.RoundedBox(4, x-31, y+h/2-1, 62, 10, Color(0,0,0,alpha))
			draw.RoundedBox(4, x-30, y+h/2, math.max(8,math.Clamp(v:Health(), 0, 100)/100*60), 8, Color(255,0,0,alpha))
		end
	end
end
