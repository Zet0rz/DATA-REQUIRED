if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Turret"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Deploy an automatic Turret"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "pistol"

SWEP.AttachModel = "models/airboatgun.mdl"
SWEP.AttachScale = 1

local duration = 10
SWEP.Instructions	= "LMB to deploy Turret - Turret lasts for "..duration.." seconds"

function SWEP:PrimaryAttack()
	if SERVER then
		local turret = ents.Create("data_turret")
		turret:SetPos(self.Owner:GetPos())
		turret:SetDuration(duration)
		turret:SetRange(500)
		turret:SetDamage(100)
		turret:Spawn()
		turret.Owner = self.Owner
		
		self:Finish()
	end
end

function SWEP:Think()
	
end

function SWEP:OnRemove()
	
end

GAMEMODE:AddWeaponPickup("proto_turret", 70, Color(100,0,0), SWEP.AttachModel, 1, Vector(-10,0,0))