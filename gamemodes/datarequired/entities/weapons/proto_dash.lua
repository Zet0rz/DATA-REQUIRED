if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Swift Strike"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Dash ahead, slicing any enemy in front of you"
SWEP.Instructions	= "LMB to dash - You will need healing"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "rpg"

SWEP.AttachModel = "models/props_c17/trappropeller_blade.mdl"
SWEP.AttachScale = 1

function SWEP:PrimaryAttack()
	
end

function SWEP:Think()
	
end

function SWEP:OnRemove()
	
end

--GAMEMODE:AddWeaponPickup("proto_missile", Color(100,0,0), SWEP.AttachModel, 1)