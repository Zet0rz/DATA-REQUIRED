if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Missile"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Shoot a Remote Controlled Missile"
SWEP.Instructions	= "Get it from a weapon drop"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "rpg"

SWEP.AttachModel = "models/weapons/w_missile.mdl"
SWEP.AttachScale = 1

function SWEP:PrimaryAttack()
	if not self.Missile then
		self.Missile = ents.Create("data_missile")
		self.Missile:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector()*25)
		self.Missile:SetAngles(self.Owner:GetAimVector():Angle())
		self.Missile.Owner = self
		self.Missile:Spawn()
	end
end

function SWEP:Think()
	if self.Missile and not IsValid(self.Missile) then
		self:Finish()
	end
end

function SWEP:OnRemove()
	if IsValid(self.Missile) then self.Missile:Explode() end
end

--GAMEMODE:AddWeaponPickup("proto_missile", Color(100,0,0), SWEP.AttachModel, 1)