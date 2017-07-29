if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Gatling Gun"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Fire lost of small, low damage bullets"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Primary.Automatic	= true

SWEP.HoldType = "shotgun"

SWEP.AttachModel = "models/combine_turrets/combine_cannon_gun.mdl"
SWEP.AttachScale = 2
SWEP.AttachOffset = Vector(0,0,-10)

local speed = 800
local size = 10
local delay = 0.1
local maxshots = 20
local damage = 35
local accuracy = 15 -- The angle of the spread
local maxbounces = 2

SWEP.Instructions	= "Hold LMB to fire bullets - Has a total of "..maxshots.." bullets"

local shootsound = Sound("weapons/ar2/fire1.wav")

function SWEP:PrimaryAttack()
	if SERVER then
		local ct = CurTime()
		if not self.NextShot or self.NextShot < ct then
			local pos = self.Owner:GetShootPos() + self.Owner:GetAimVector()*25
			local vel = speed*self.Owner:GetAimVector()
			vel:Rotate(Angle(0,math.random(-accuracy, accuracy),0))
			
			local applyfunc = function(bul) bul.MaxBounces = maxbounces end
			self.Owner:FireProjectile(size, pos, vel, damage, applyfunc)
			self.Owner:EmitSound(shootsound)
			self.NextShot = ct + delay
			if not self.NumShots then self.NumShots = 1
			else
				self.NumShots = self.NumShots + 1
				if self.NumShots >= maxshots then
					self:Finish()
				end
			end
		end
	end
end

GAMEMODE:AddWeaponPickup("proto_gatling", 100, Color(150,150,150), SWEP.AttachModel, 1.75, nil, Angle(0,-45,0))