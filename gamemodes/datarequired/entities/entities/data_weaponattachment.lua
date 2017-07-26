
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Virtual Weapon"
ENT.Author			= "Zet0r"
ENT.Information		= "The virtual weapon equipped from weapon drops"

--ENT.Base			= "prop_physics"

function ENT:Initialize()
	if CLIENT then
		self:SetPredictable(false)
	end
end