local ply = FindMetaTable("Player")
local ent = FindMetaTable("Entity")

function ent:FireProjectile(size, pos, vel, d)
	local bul = ents.Create("data_projectile")
	bul:SetSize(size)
	bul:SetPos(pos)
	
	if not d or type(d) == "number" then
		local num = d or 100
		d = DamageInfo()
		d:SetDamage(num)
		d:SetDamageType(DMG_BULLET)
	end
	
	d:SetAttacker(self)
	d:SetInflictor(bul)
	
	bul:SetDamage(d)
	
	bul:Spawn()
	bul:SetSpeedVector(vel)
	
	--print(vel)
	--timer.Simple(0.1, function() print(bul:GetVelocity()) end)
end