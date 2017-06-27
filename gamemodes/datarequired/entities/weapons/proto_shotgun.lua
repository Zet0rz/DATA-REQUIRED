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
SWEP.Instructions	= "Get it from a weapon drop"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "ar2"

SWEP.AttachModel = "models/props_junk/watermelon01.mdl"
SWEP.AttachScale = 1

local speed = 3000

function SWEP:PrimaryAttack()
	local laser = ents.Create("data_laserhead")
	laser:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector()*5)
	laser:Spawn()
	laser.Owner = self.Owner
	
	local phys = laser:GetPhysicsObject()
	phys:SetVelocity(self.Owner:GetAimVector()*speed)
end

GAMEMODE:AddWeaponPickup("proto_laser", Color(255,0,0), SWEP.AttachModel, 1)