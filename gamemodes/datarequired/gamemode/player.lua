local ply = FindMetaTable("Player")
local ent = FindMetaTable("Entity")

function ply:EnableEditor(bool)
	self.ChamberEditing = bool
	self:ChatPrint(bool and "You are now editing the chamber" or "You are no longer editing the chamber")
	
	net.Start("data_chamberedit")
		net.WriteBool(bool)
	net.Send(self)
end

function ply:GetEditing()
	return self.ChamberEditing
end

local startx = -960
local starty = 704
local gridsize = 128
function ply:GetGridCoordinate()
	local pos = self:GetPos()
	local x = math.floor((pos.x-startx)/gridsize)
	local y = math.floor((starty-pos.y)/gridsize)
	
	return x,y
end

function GetGridCoordinateCenter(x,y)
	return Vector(startx + x*gridsize + gridsize/2, starty - y*gridsize - gridsize/2, 66)
end