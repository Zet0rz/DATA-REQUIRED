
-- A sort of 2D table where each key is the respective coordinate (starting top left)
GM.CurrentMap = GM.CurrentMap or {
	wallx = { -- Has walls in coordinate 0 on X axis
		[0] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[1] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[2] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[3] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[4] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[5] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[6] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[7] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[8] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[9] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[10] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[11] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[12] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[13] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[14] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
	},
	wally = { -- Has coordinate 0 on Y axis
		[1] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[2] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[3] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[4] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[5] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[6] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[7] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[8] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[9] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[10] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[11] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[12] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[13] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[14] = {[0]=false, [1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
	},
	block = { -- Has coordinate 0 on both axis
		[0] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[1] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[2] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[3] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[4] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[5] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[6] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[7] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[8] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[9] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[10] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[11] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[12] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[13] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
		[14] = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true},
	},
	corner = { -- Has coordinate 0 on neither axis
		[1] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[2] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[3] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[4] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[5] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[6] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[7] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[8] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[9] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[10] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[11] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[12] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[13] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
		[14] = {[1]=false, [2]=false, [3]=false, [4]=false, [5]=false, [6]=false, [7]=false, [8]=false},
	},
}

local function cornercondition(x,y,target)
	local w1 = GAMEMODE.CurrentMap.wallx[x][y]
	local w2 = GAMEMODE.CurrentMap.wally[x][y]

	-- Any of the walls on the same line not equal, corner must be up
	if ((GAMEMODE.CurrentMap.wallx[x-1][y]~=w1) or (GAMEMODE.CurrentMap.wally[x][y-1]~=w2)) then return true end
	if w1 ~= w2 then return false end -- They are different, corner must be down
	if w1 then return true end -- They are both up, corner must be up
	
	return target
end
function OpenCorner(x,y, bool, forced)
	local target = not GAMEMODE.CurrentMap.corner[x][y]
	if bool ~= nil then
		target = bool
	end
	
	-- Condition: Only allow toggle if all adjacent walls are down
	target = cornercondition(x,y,target)
	if not forced and target == GAMEMODE.CurrentMap.corner[x][y] then return end
	
	local door = ents.FindByName("corner-"..x.."-"..y)[1]
	if IsValid(door) then
		door:Fire(target and "Close" or "Open")
		if not noedit then GAMEMODE.CurrentMap.corner[x][y] = target end
	end
end

local function wallxcondition(x,y,target)
	local b1 = GAMEMODE.CurrentMap.block[x][y]
	
	-- Blocks on either side are different, stay up!
	if b1 ~= GAMEMODE.CurrentMap.block[x][y-1] then return true end
	if b1 then return false end-- Both blocks are up, stay down!
	
	-- Both are down, allow target
	return target
end
function OpenWallX(x,y, bool, forced) -- If no bool is supplied, toggle
	local target = not GAMEMODE.CurrentMap.wallx[x][y]
	if bool ~= nil then
		target = bool
	end
	
	-- Condition: Only allow toggle if adjacent blocks are down
	target = wallxcondition(x,y,target)
	if not forced and target == GAMEMODE.CurrentMap.wallx[x][y] then return end
	
	local door = ents.FindByName("wallx-"..x.."-"..y)[1]
	if IsValid(door) then
		door:Fire(target and "Close" or "Open")
		if not noedit then GAMEMODE.CurrentMap.wallx[x][y] = target end
		
		-- Lower corners if they can be lowered
		-- OpenCorner checks conditions itself
		if GAMEMODE.CurrentMap.corner[x] and GAMEMODE.CurrentMap.corner[x][y] ~= nil then OpenCorner(x,y,false) end
		if GAMEMODE.CurrentMap.corner[x+1] and GAMEMODE.CurrentMap.corner[x+1][y] ~= nil then OpenCorner(x+1,y,false) end 
	end
end

local function wallycondition(x,y,target)
	local b1 = GAMEMODE.CurrentMap.block[x][y]
	
	-- Blocks on either side are different, stay up!
	if b1 ~= GAMEMODE.CurrentMap.block[x-1][y] then return true end
	if b1 then return false end-- Both blocks are up, stay down!
	
	-- Both are down, allow target
	return target
end
function OpenWallY(x,y, bool, forced) -- If no bool is supplied, toggle
	local target = not GAMEMODE.CurrentMap.wally[x][y]
	if bool ~= nil then
		target = bool
	end
	
	-- Condition: Only allow toggle if adjacent blocks are down
	target = wallycondition(x,y,target)
	if not forced and target == GAMEMODE.CurrentMap.wally[x][y] then return end
	
	local door = ents.FindByName("wally-"..x.."-"..y)[1]
	if IsValid(door) then
		door:Fire(target and "Close" or "Open")
		if not noedit then GAMEMODE.CurrentMap.wally[x][y] = target end
		
		-- Lower corners if possible
		if GAMEMODE.CurrentMap.corner[x][y] ~= nil then OpenCorner(x,y,false) end
		if GAMEMODE.CurrentMap.corner[x][y+1] ~= nil then OpenCorner(x,y+1,false) end 
	end
end

-- Blocks have no condition, they always allow toggling
-- They act as the outer-most layer of controlling entities
function OpenBlock(x,y, bool, forced)
	local target = not GAMEMODE.CurrentMap.block[x][y]
	if bool ~= nil then
		target = bool
	end
	
	if not forced and target == GAMEMODE.CurrentMap.block[x][y] then return end
	
	local door = ents.FindByName("block-"..x.."-"..y)[1]
	if IsValid(door) then
		if target then
			timer.Simple(0.1, function() if IsValid(door) then door:Fire("Close") end end)
			GAMEMODE.WeaponGrid[x..";"..y] = nil
		else
			door:Fire("Open")
			GAMEMODE.WeaponGrid[x..";"..y] = false
		end
		GAMEMODE.CurrentMap.block[x][y] = target
		
		-- Blocks don't manage corners, instead they manage the walls on their sides
		-- (which in turn manage their respective corners)
		-- Lower the walls if they exist and can
		if GAMEMODE.CurrentMap.wallx[x][y] ~= nil then OpenWallX(x,y,false) end
		if GAMEMODE.CurrentMap.wallx[x][y+1] ~= nil then OpenWallX(x,y+1,false) end
		
		if GAMEMODE.CurrentMap.wally[x] and GAMEMODE.CurrentMap.wally[x][y] ~= nil then OpenWallY(x,y,false) end
		if GAMEMODE.CurrentMap.wally[x+1] and GAMEMODE.CurrentMap.wally[x+1][y] ~= nil then OpenWallY(x+1,y,false) end
	end
end

hook.Add("InitPostEntity", "data_defaultmap", function()
	for k,v in pairs(GAMEMODE.CurrentMap.wallx) do
		for k2,v2 in pairs(v) do
			local ent = ents.FindByName("wallx-"..k.."-"..k2)[1]
			if IsValid(ent) then ent:Fire(v2 and "Close" or "Open") end
		end
	end
	for k,v in pairs(GAMEMODE.CurrentMap.wally) do
		for k2,v2 in pairs(v) do
			local ent = ents.FindByName("wally-"..k.."-"..k2)[1]
			if IsValid(ent) then ent:Fire(v2 and "Close" or "Open") end
		end
	end
	for k,v in pairs(GAMEMODE.CurrentMap.block) do
		for k2,v2 in pairs(v) do
			local ent = ents.FindByName("block-"..k.."-"..k2)[1]
			if IsValid(ent) then ent:Fire(v2 and "Close" or "Open") end
		end
	end
	for k,v in pairs(GAMEMODE.CurrentMap.corner) do
		for k2,v2 in pairs(v) do
			local ent = ents.FindByName("corner-"..k.."-"..k2)[1]
			if IsValid(ent) then ent:Fire(v2 and "Close" or "Open") end
		end
	end
end)

function GM:ShowHelp(ply)
	if ply:IsSuperAdmin() then
		ply:EnableEditor(not ply:GetEditing())
	end
end

util.AddNetworkString("data_chamberedit")
net.Receive("data_chamberedit", function(len, ply)
	if ply:GetEditing() then
		local ent = net.ReadEntity()
		
		if not IsValid(ent) then -- Retrace down through the floor
			local pos = net.ReadVector()
			--[[local tr = util.TraceLine({
				start = pos,
				endpos = pos - Vector(0,0,100),
				filter = function(ent)
					return ent:GetClass() == "func_door"
				end,
				ignoreworld = true,
			})]]
			--PrintTable(tr)
			--ent = tr.Entity
			
			-- Either we can do a direct downward trace, or we can search in sphere and prioritize smaller targets
			-- This makes it easier to click corners and walls instead of the bigger blocks
			local doors = ents.FindInSphere(pos, 20)
			local types = {}
			for k,v in ipairs(doors) do
				if v:GetClass() == "func_door" then
					local name = v:GetName()
					local pattern = "(%a+)-[%d+]"
					local dtype = string.match(name, pattern)
					types[dtype] = v
				end
			end
			
			ent = IsValid(types.corner) and types.corner or IsValid(types.wallx) and types.wallx or IsValid(types.wally) and types.wally or IsValid(types.block) and types.block
			
		end
		
		if IsValid(ent) then
			local name = ent:GetName()
			local pattern = "-(%d+)-(%d+)$"
			local x,y = string.match(name, pattern)
			x = tonumber(x)
			y = tonumber(y)
			
			if not x or not y then print("No x or y") return end
			
			if string.match(name, "^block") then
				OpenBlock(x,y)
			elseif string.match(name, "^wallx") then
				OpenWallX(x,y)
			elseif string.match(name, "^wally") then
				OpenWallY(x,y)
			elseif string.match(name, "^corner") then
				OpenCorner(x,y)
			end
		else
		end
	end
end)

function IsValidGridCoordinate(x,y)
	return GAMEMODE.CurrentMap.block[x] and (GAMEMODE.CurrentMap.block[x][y] == false)
end