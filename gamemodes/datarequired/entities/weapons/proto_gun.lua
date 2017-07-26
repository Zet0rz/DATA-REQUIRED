if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Test Gun"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Shoot a small volley of projectiles"
SWEP.Instructions	= "Get it from a weapon drop"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "shotgun"

SWEP.WorldModel = "models/weapons/w_shotgun.mdl" -- model for shotgun?

healths = {90, 100, 50, 100, 0, 100}
function SWEP:PrimaryAttack()
	if not self.Uses then self.Uses = 1 end
	self.Owner:SetHealth(healths[self.Uses])
	self.Uses = self.Uses + 1
	if self.Uses > #healths then self.Uses = 1 end
end

function SWEP:SecondaryAttack()
	self:Finish()
end