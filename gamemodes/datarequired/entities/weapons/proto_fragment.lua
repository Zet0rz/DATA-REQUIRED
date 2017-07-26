if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Fragment Cannon"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Shoot a cannonball that explodes into a ring of fragments"
SWEP.Instructions	= "LMB to fire cannonball - LMB again to explode"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "revolver"

SWEP.AttachModel = "models/combine_turrets/floor_turret_gib3.mdl"
SWEP.AttachScale = 1.5
SWEP.AttachOffset = Vector(10,-4,0)

local speed = 300
local size = 30
local fragmentsize = 10
local fragmentspeed = 300
local numfragments = 30

local shootsound = Sound("weapons/ar2/ar2_altfire.wav")
local explodesound = Sound("weapons/ar2/npc_ar2_altfire.wav")

function SWEP:PrimaryAttack()
	if SERVER then
		if not IsValid(self.Bullet) then
			
			
			local bullet = self.Owner:FireProjectileAim(size, speed, 100)
			bullet:SetCollideFunction(function(self2, ent)
				self:PrimaryAttack()
			end)
			self.Bullet = bullet
			self:EmitSound(shootsound)
		else
			sound.Play(explodesound, self.Bullet:GetPos(), 511, 100, 1)
			self.Bullet:Remove()
			local d = DamageInfo()
			d:SetDamage(100)
			d:SetDamageType(DMG_BULLET)
			d:SetAttacker(self.Owner)
			d:SetInflictor(self)
			
			for i = 1, numfragments do
				local vel = Angle(0,360/numfragments*i,0):Forward()*fragmentspeed
				self.Owner:FireProjectile(fragmentsize, self.Bullet:GetPos(), vel, d)
			end
			
			self:Finish()
		end
	end
	
end

GAMEMODE:AddWeaponPickup("proto_fragment", 100, Color(250,250,150), SWEP.AttachModel, 3, Vector(10,-5,0))