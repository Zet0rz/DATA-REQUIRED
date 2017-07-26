
GM.WeaponPickups = GM.WeaponPickups or {}

function GM:AddWeaponPickup(class, weight, color, model, scale, offset, angle)
	self.WeaponPickups[class] = {color = color, weight = weight, model = model, scale = scale, offset = offset, angle = angle}
end

function GM:GetWeaponPickup(class)
	return self.WeaponPickups[class]
end

function GM:PickRandomPickupClass()
	local total = 0
	for k,v in pairs(self.WeaponPickups) do
		total = total + (v.weight or 100)
	end
	
	if total > 0 then
		local ran = math.random(total)
		local counter = 0
		for k,v in pairs(self.WeaponPickups) do
			counter = counter + (v.weight or 100)
			if counter >= ran then
				return k
			end
		end
	end
	
	-- Fallback if nothing else is returned (should never happen anyway)
	local tbl = table.GetKeys(self.WeaponPickups)
	return tbl[math.random(#tbl)]
end

GM.WeaponGrid = GM.WeaponGrid or {}
function GM:ResetWeaponGridList()
	self.WeaponGrid = {}
	for k,v in pairs(self.CurrentMap.block) do
		for k2, v2 in pairs(v) do
			if not v2 then self.WeaponGrid[k..";"..k2] = false else self.WeaponGrid[k..";"..k2] = nil end
		end
	end
end

function GM:SpawnWeaponPickup(class)
	class = class or self:PickRandomPickupClass()
	local x,y = self:CalculateDesiredWeaponSpawnpoint()
	self:SpawnWeaponPickupPos(class, x, y)
end

local pattern = "(%d+);(%d+)"
function GM:CalculateDesiredWeaponSpawnpoint()
	local tbl = {}
	for k,v in pairs(self.WeaponGrid) do
		if v == false then table.insert(tbl, k) end
	end
	local str = tbl[math.random(#tbl)]
	if not str then return end
	
	local x,y = string.match(str, pattern)
	return x, y
end

function GM:SpawnWeaponPickupPos(class, x, y)
	if not (x and y) then return end
	
	class = class or self:PickRandomPickupClass()
	local wep = ents.Create("data_weaponpickup")
	wep:SetPos(GetGridCoordinateCenter(x,y))
	wep:Spawn()
	wep:SetWeaponPickup(class)
	
	local str = x..";"..y
	if self.WeaponGrid[str] == false then self.WeaponGrid[str] = true end
	wep.GridString = str
end

local spawndelay = CreateConVar("dreq_weaponfrequency", 5, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Sets how big a delay between weapon drop spawns")
local nextspawn = 0
function GM:Think()
	local ct = CurTime()
	if self.RoundOngoing and nextspawn < ct then
		self:SpawnWeaponPickup(self:PickRandomPickupClass())
		nextspawn = ct + spawndelay:GetInt()
	end
end
cvars.AddChangeCallback("dreq_weaponfrequency", function(convar, old, new)
	local num = tonumber(new)
	if num then
		nextspawn = CurTime() + num
	else
		nextspawn = 0
	end
end)