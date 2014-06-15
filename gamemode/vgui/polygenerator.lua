PolyGen = {}

function PolyGen:SecondstoHMS (seconds)
	local h,m,s

	h = math.floor(seconds / 3600,0)
	m = math.floor ((seconds - h * 3600) / 60,0)
	s = seconds - (h * 3600 + m * 60)
	return h,m,s
end

function PolyGen:FormatSeconds(seconds)
	h,m,s = self:SecondstoHMS(seconds)
	return (m>9 and m or "0" .. m) .. ":" .. (s>9 and s or "0" .. s)
end

function PolyGen:GeneratePolyBar(x,y, width, height, mod)
	mod = mod or 15
	Poly = {}

	Poly[1] = {}
	Poly[1]["x"] = x
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1

	Poly[2] = {}
	Poly[2]["x"] = x+width
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1

	Poly[3] = {}
	Poly[3]["x"] = x+width+mod
	Poly[3]["y"] = y+height
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1

	Poly[4] = {}
	Poly[4]["x"] = x+mod
	Poly[4]["y"] = y+height
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyBarInverted(x,y, width, height, mod)
	mod = mod or 15
	Poly = {}

	Poly[1] = {}
	Poly[1]["x"] = x+mod
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1

	Poly[2] = {}
	Poly[2]["x"] = x+width+mod
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1

	Poly[3] = {}
	Poly[3]["x"] = x+width
	Poly[3]["y"] = y+height
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1

	Poly[4] = {}
	Poly[4]["x"] = x
	Poly[4]["y"] = y+height
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyBarTII(x,y, width, height, mod)
	mod = mod or 15
	Poly = {}

	Poly[1] = {}
	Poly[1]["x"] = x
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1

	Poly[2] = {}
	Poly[2]["x"] = x+width+mod
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1

	Poly[3] = {}
	Poly[3]["x"] = x+width
	Poly[3]["y"] = y+height
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1

	Poly[4] = {}
	Poly[4]["x"] = x+mod
	Poly[4]["y"] = y+height
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyHalfBar(x,y, width, height, mod)
	mod = mod or 0
	Poly = {}

	Poly[1] = {}
	Poly[1]["x"] = x
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1

	Poly[2] = {}
	Poly[2]["x"] = x+width
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1

	Poly[3] = {}
	Poly[3]["x"] = x+width+(height*(20/25))
	Poly[3]["y"] = y+height
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1

	Poly[4] = {}
	Poly[4]["x"] = x
	Poly[4]["y"] = y+height
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyHalfBarInverted(x,y, width, height, mod)
	mod = mod or 0
	Poly = {}

	Poly[1] = {}
	Poly[1]["x"] = x+(height*(20/25))
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1

	Poly[2] = {}
	Poly[2]["x"] = x+width
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1

	Poly[3] = {}
	Poly[3]["x"] = x+width
	Poly[3]["y"] = y+height
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1

	Poly[4] = {}
	Poly[4]["x"] = x
	Poly[4]["y"] = y+height
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyBarCutOff(x,y, width, height)
	Poly = {}

	Poly[1] = {}
	Poly[1]["x"] = x
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1

	Poly[2] = {}
	Poly[2]["x"] = x+width
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1

	Poly[3] = {}
	Poly[3]["x"] = x+width+11
	Poly[3]["y"] = y+height-7
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1

	Poly[4] = {}
	Poly[4]["x"] = x+width+7
	Poly[4]["y"] = y+height
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	Poly[5] = {}
	Poly[5]["x"] = x+15
	Poly[5]["y"] = y+height
	Poly[5]["u"] = 1
	Poly[5]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyBarCutOffLast(x,y, width, height)
	Poly = {}

	Poly[1] = {}
	Poly[1]["x"] = x
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1

	Poly[2] = {}
	Poly[2]["x"] = x+width
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1

	Poly[3] = {}
	Poly[3]["x"] = x+9
	Poly[3]["y"] = y+height
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyBarCutOffFirst(x,y, width, height)
	Poly = {}

	Poly[1] = {}
	Poly[1]["x"] = x
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1

	Poly[2] = {}
	Poly[2]["x"] = x+10
	Poly[2]["y"] = y+height
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1

	Poly[3] = {}
	Poly[3]["x"] = x
	Poly[3]["y"] = y+height
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyTimerTop(x,y)
	Poly = {}
	 
	Poly[1] = {}
	Poly[1]["x"] = x-95
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1
	 
	Poly[2] = {}
	Poly[2]["x"] = x+95
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1
	 
	Poly[3] = {}
	Poly[3]["x"] = x+77
	Poly[3]["y"] = y+30
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1
	 
	Poly[4] = {}
	Poly[4]["x"] = x-77
	Poly[4]["y"] = y+30
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyTimerMiddle(x,y)
	Poly = {}
	 
	Poly[1] = {}
	Poly[1]["x"] = x-233
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1
	 
	Poly[2] = {}
	Poly[2]["x"] = x+233
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1
	 
	Poly[3] = {}
	Poly[3]["x"] = x+215
	Poly[3]["y"] = y+30
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1
	 
	Poly[4] = {}
	Poly[4]["x"] = x-215
	Poly[4]["y"] = y+30
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	return Poly
end

function PolyGen:GeneratePolyTimerBottom(x,y)
	Poly = {}
	 
	Poly[1] = {}
	Poly[1]["x"] = x-60
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1
	 
	Poly[2] = {}
	Poly[2]["x"] = x+60
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1
	 
	Poly[3] = {}
	Poly[3]["x"] = x+45
	Poly[3]["y"] = y+25
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1
	 
	Poly[4] = {}
	Poly[4]["x"] = x-45
	Poly[4]["y"] = y+25
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	return Poly
end