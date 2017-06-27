if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Melon Bomb"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Drop a melonbomb from Melonbomber that blows up the grid on X and Y axis"
SWEP.Instructions	= "Get it from a weapon drop"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "grenade"

local delay = 4

SWEP.AttachModel = "models/props_junk/watermelon01.mdl"
SWEP.AttachScale = 1

-- TODO: Make explosion sound only play once

function SWEP:PrimaryAttack()
	local x,y = self.Owner:GetGridCoordinate()
	if IsValidGridCoordinate(x,y) then
		local ply = self.Owner
		local pos = GetGridCoordinateCenter(x,y)
		local bomb = ents.Create("prop_physics")
		bomb:SetModel("models/props_junk/watermelon01.mdl")
		bomb:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		bomb:SetNotSolid(true)
		bomb:SetPos(pos + Vector(0,0,50))
		bomb:SetModelScale(2)
		bomb:Spawn()
		bomb:SetMoveType(MOVETYPE_NONE)
		
		timer.Simple(delay, function()
			if IsValid(bomb) then
				local expls = {x = {}, y = {}}
				local x2 = x+1
				while (IsValidGridCoordinate(x2,y)) do
					if GAMEMODE.CurrentMap.wally[x2][y] then break end
					expls.x[x2] = true
					x2 = x2+1
				end
				x2 = x-1
				while (IsValidGridCoordinate(x2,y)) do
					if GAMEMODE.CurrentMap.wally[x2+1][y] then break end
					expls.x[x2] = true
					x2 = x2-1
				end
				
				local y2 = y+1
				while (IsValidGridCoordinate(x,y2)) do
					if GAMEMODE.CurrentMap.wallx[x][y2] then break end
					expls.y[y2] = true
					y2 = y2+1
				end
				y2 = y-1
				while (IsValidGridCoordinate(x,y2)) do
					if GAMEMODE.CurrentMap.wallx[x][y2+1] then break end
					expls.y[y2] = true
					y2 = y2-1
				end
				
				local e = EffectData()
				for k,v in pairs(expls.x) do
					e:SetOrigin(GetGridCoordinateCenter(k,y))
					util.Effect("Explosion", e, true)
				end
				for k,v in pairs(expls.y) do
					e:SetOrigin(GetGridCoordinateCenter(x,k))
					util.Effect("Explosion", e, true)
				end
				e:SetOrigin(GetGridCoordinateCenter(x,y))
				util.Effect("Explosion", e, true)
				
				local d = DamageInfo()
				d:SetDamage(100)
				d:SetAttacker(ply)
				d:SetAttacker(bomb)
				d:SetDamageType(DMG_BLAST)
				for k,v in pairs(player.GetAll()) do
					if v:Alive() then
						local x3,y3 = v:GetGridCoordinate()
						if (expls.x[x3] and y3 == y) or (expls.y[y3] and x3 == x) then
							v:TakeDamageInfo(d)
						end
					end
				end
				
				bomb:Remove()
			end
		end)
		
		self:Finish()
	end
end

GAMEMODE:AddWeaponPickup("proto_melonbomb", Color(0,255,0), SWEP.AttachModel, 2)