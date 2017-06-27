
weppickups = weppickups or {}

function GM:AddWeaponPickup(class, color, model, scale)
	weppickups[class] = {color = color, model = model, scale = scale}
end

function GM:GetWeaponPickup(class)
	return weppickups[class]
end

function GM:PickRandomPickupClass()
	local tbl = table.GetKeys(weppickups)
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