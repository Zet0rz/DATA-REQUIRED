if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Invisible Mine"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Places a mine that turns invisible shortly after and explodes when stepped on"
SWEP.Instructions	= "Press LMB to place mine at your current location"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "pistol"

SWEP.AttachModel = "models/props_combine/combine_mine01.mdl"
SWEP.AttachScale = 1

function SWEP:PrimaryAttack()
	if SERVER then
		local mine = ents.Create("data_mine")
		mine:SetPos(self.Owner:GetPos())
		mine.Owner = self.Owner
		mine:Spawn()
		
		self:Finish()
	end
end

GAMEMODE:AddWeaponPickup("proto_mine", 80, Color(0,0,100), SWEP.AttachModel, 1)