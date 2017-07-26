if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Shotgun"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Shoot a small volley of projectiles"
SWEP.Instructions	= "Press LMB to fire 5 bullets in a cone"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "shotgun"

SWEP.WorldModel = "models/weapons/w_shotgun.mdl" -- model for shotgun?

local speed = 800
local size = 10

local shootsound = Sound("weapons/shotgun/shotgun_fire7.wav")

function SWEP:PrimaryAttack()
	if SERVER then
		local pos = self.Owner:GetShootPos() + self.Owner:GetAimVector()*25
		local vel = speed*self.Owner:GetAimVector()
		local vel2 = speed*self.Owner:GetAimVector()
		vel2:Rotate(Angle(0,10,0))
		local vel3 = speed*self.Owner:GetAimVector()
		vel3:Rotate(Angle(0,20,0))
		local vel4 = speed*self.Owner:GetAimVector()
		vel4:Rotate(Angle(0,-10,0))
		local vel5 = speed*self.Owner:GetAimVector()
		vel5:Rotate(Angle(0,-20,0))
		
		local d = DamageInfo()
		d:SetDamage(100)
		d:SetDamageType(DMG_BULLET)
		d:SetAttacker(self.Owner)
		d:SetInflictor(self)
		
		self.Owner:FireProjectile(size, pos, vel, d)
		self.Owner:FireProjectile(size, pos, vel2, d)
		self.Owner:FireProjectile(size, pos, vel3, d)
		self.Owner:FireProjectile(size, pos, vel4, d)
		self.Owner:FireProjectile(size, pos, vel5, d)
		
		self.Owner:EmitSound(shootsound)
		self:Finish()
	end
end

GAMEMODE:AddWeaponPickup("proto_shotgun", 100, Color(150,150,150), SWEP.WorldModel, 2, Vector(0,0,5), Angle(0,0,90))