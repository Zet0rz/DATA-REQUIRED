if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Laser Rifle"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Shoot a fast-moving bouncing laser"
SWEP.Instructions	= "LMB to fire laser - Be careful! It might bounce back and hit you!"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "pistol"

SWEP.AttachModel = "models/props_rooftop/roof_dish001.mdl"
SWEP.AttachScale = 0.5
SWEP.AttachOffset = Vector(0,0,-20)

local speed = 3000

local shootsound = Sound("weapons/irifle/irifle_fire2.wav")

function SWEP:PrimaryAttack()
	if SERVER then
		local laser = self:CreateEntity("data_laserhead")
		laser:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector()*25)
		laser:Spawn()
		laser.Owner = self.Owner
		self.Owner:EmitSound(shootsound)
		
		local phys = laser:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector()*speed)
		self:Finish()
	end
end

GAMEMODE:AddWeaponPickup("proto_laser", 100, Color(255,0,0), SWEP.AttachModel, 0.75, Vector(-25,5,0), Angle(180,90,90))