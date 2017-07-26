if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Rezurrector"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Revive a dead test subject to fight by your side"
SWEP.Instructions	= "Use near dead body to revive - RMB to destroy"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "pistol"

SWEP.AttachModel = "models/effects/intro_vortshield.mdl"
SWEP.AttachScale = 1
SWEP.AttachAngle = Angle(90,0,0)

local range = 100^2

function SWEP:PrimaryAttack()
	if SERVER then
		for k,v in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
			local rag = v:GetRagdollEntity()
			if IsValid(rag) and rag:GetPos():DistToSqr(self.Owner:GetPos()) <= range then
				v:SetTeam(TEAM_TESTSUBJECTS)
				v.Owner = self.Owner
				v:Spawn()
				v:SetPos(rag:GetPos())
				self:Finish()
				break
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self:Finish()
end

--GAMEMODE:AddWeaponPickup("proto_missile", Color(100,0,0), SWEP.AttachModel, 1)