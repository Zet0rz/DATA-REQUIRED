
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "The head of the Laser Sniper projectile"
ENT.Author			= "Zet0r"
ENT.Information		= "The main objective"

--ENT.Base			= "prop_physics"

function ENT:Initialize()
	if CLIENT then
		self:SetPredictable(false)
	end
end