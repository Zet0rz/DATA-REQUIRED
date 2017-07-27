local ply = FindMetaTable("Player")
local ent = FindMetaTable("Entity")

function ent:FireProjectile(size, pos, vel, d, applyfunc)
	local bul = ents.Create("data_projectile2")
	bul:SetSize(size)
	bul:SetPos(pos)
	
	if not d or type(d) == "number" then
		local num = d or 100
		d = DamageInfo()
		d:SetDamage(num)
		d:SetDamageType(DMG_BULLET)
	end
	
	d:SetAttacker(self.Owner or self)
	d:SetInflictor(bul)
	
	bul:SetDamage(d)
	bul:SetAttacker(self)
	
	-- Let's you apply data to the bullet before it is spawned
	if applyfunc then applyfunc(bul) end
	
	bul:Spawn()
	bul:SetSpeedVector(vel)
	
	return bul
end

function ply:FireProjectileAim(size, speed, d, applyfunc)
	local pos = self:GetShootPos() + self:GetAimVector()*25
	local vel = speed*self:GetAimVector()
	
	return self:FireProjectile(size, pos, vel, d, applyfunc)
end

-- Overwrite EmitSound so that it has the range to reach the camera
local old = ent.EmitSound
function ent:EmitSound(sound, lvl, pitch, vol, chan)
	-- Change the default level to 300 if no other level is passed
	old(self, sound, lvl or 511, pitch, vol, chan)
end

-- Used to determine sound, based on player model
-- The same system as used in Sacrifun; my other gamemode
function ply:IsFemale()
	local fe = (string.find(self:GetModel(), "female"))
	return fe ~= nil
end

function ply:Moan()
	if self:IsFemale() then
		self:EmitSound("vo/npc/female01/moan0"..math.random(1,5)..".wav", nil, math.random(95,105))
	else
		self:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav", nil, math.random(95,105))
	end
end

function ply:Scream(loud) -- True = loud screams, false = low screams, nil = all - Doesn't affect females (no loud sounds)
	local fe = self:IsFemale() and "fe" or ""
	local start = loud and 7 or 1
	local notloud = loud == false and 6 or 9
	self:EmitSound("vo/npc/"..fe.."male01/pain0"..math.random(start,notloud)..".wav", nil, math.random(95,105))
end

function ply:Cheer()
	if self:IsFemale() then
		self:EmitSound("vo/coast/odessa/female01/nlo_cheer0"..math.random(1,3)..".wav", nil, math.random(95,105))
	else
		self:EmitSound("vo/coast/odessa/male01/nlo_cheer0"..math.random(1,4)..".wav", nil, math.random(95,105))
	end
end

function ply:Shout()
	local fe = self:IsFemale() and "fe" or ""
	if math.random(0,1) == 0 then
		self:EmitSound("vo/coast/odessa/"..fe.."male01/nlo_cubdeath0"..math.random(1,2)..".wav", nil, 100)
	else
		self:EmitSound("vo/npc/"..fe.."male01/no0"..math.random(1,2)..".wav", nil, 100)
	end
end