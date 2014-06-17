--[[
	subtable:
	{
		entityID = EntityID
		owner = Player
	}
]]
GM.MapButtons = {}
GM.TableMap = {}

-- Updates the ownership status for buttons
net.Receive("DeathRun_UpdateButtons", function (length)
	local id, owner, tblID
	for i=1, net.ReadUInt(8) do
		id = net.ReadUInt(16)
		owner = net.ReadEntity()
		if owner:IsWorld() then owner = nil end

		if !GAMEMODE.TableMap[id] then
			tblID = #GAMEMODE.MapButtons+1
			GAMEMODE.MapButtons[tblID] = {}
			GAMEMODE.TableMap[id] = tblID
		end

		GAMEMODE.MapButtons[GAMEMODE.TableMap[id]].entityID = id
		GAMEMODE.MapButtons[GAMEMODE.TableMap[id]].owner = owner
	end
end)

-- Claim system HUD
function GM:HUDDrawButtons()
	local ent
	local players = player.GetAll()

	-- Loop all buttons
	for k,v in pairs(self.MapButtons) do
		-- Don't show button HUD if the button is not owned and player is not death or is dead.
		if v.owner == nil and (LocalPlayer():Team() != TEAM_DEATH or not LocalPlayer():Alive()) then continue end

		ent = Entity(v.entityID)
		if !IsValid(ent) then continue end
		local distance = self:VecDistance(LocalPlayer():GetPos(), ent:GetPos())
		-- Only show HUD if player is less than 200 units away.
		if distance < 200 then
			local vec = ent:GetPos()

			local tracedata = {}
			tracedata.start = LocalPlayer():GetShootPos()
			tracedata.endpos = vec
			tracedata.filter = players

			local trace = util.TraceLine(tracedata)

			-- Hide HUD if button is not visible.
			if !trace.HitNonWorld or trace.Entity != ent then continue end

			vec:Add(Vector(0,0,20))
			local TC = vec:ToScreen()
			local x = TC.x
			local y = TC.y

			local alpha = 255
			if distance > 100 then
				alpha = 255-(distance-100)*2.55
			end

			local text = IsValid(v.owner) and "Claimed by '" .. v.owner:Nick() .. "'."  or "Press C to claim trap."
			local font = "DR_HudTargetID"

			surface.SetFont( font )
			local w, h = surface.GetTextSize( text )

			draw.NoTexture()
			surface.SetDrawColor( 0, 0, 0, math.min(alpha,200) )
			surface.DrawPoly( PolyGen:GeneratePolyBarInverted(x-(w/2)-15, y-(h/2)-3, w+15, h+6) )

			draw.SimpleTextOutlined( text, font, x, y, Color(255,255,255,alpha), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER, 1, Color(0,0,0,alpha))
		end
	end
end

-- Claim button with C
function GM:OnContextMenuOpen()
	RunConsoleCommand("dr_claimbutton")
end