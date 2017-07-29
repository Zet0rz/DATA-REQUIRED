if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Airstrike"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Call down a missile from above"
SWEP.Instructions	= "Click anywhere to target the aistrike"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "pistol"

SWEP.AttachModel = "models/xqm/hydcontrolbox.mdl"
SWEP.AttachScale = 2

if CLIENT then
	local clicksound = Sound("garrysmod/content_downloaded.wav")
	function SWEP:OnScreenClick(vec)
		local pos, ang = GetCamPos()
		self:SendVector(util.IntersectRayWithPlane(pos, vec, self.Owner:GetPos(), Vector(0,0,1)))
		surface.PlaySound(clicksound)
		print("Sent", util.IntersectRayWithPlane(pos, vec, self.Owner:GetPos(), Vector(0,0,1)))
	end
else
	function SWEP:ReceiveVector(vec)
		print("Gotten", vec)
		if not self.Fired then
			local missile = self:CreateEntity("data_airstrike")
			missile:SetPos(vec)
			missile.Owner = self.Owner
			missile:Spawn()
			missile:Drop(1.5)
			self.Fired = true
			self:Finish()
		end
	end
end

GAMEMODE:AddWeaponPickup("proto_airstrike", 100, Color(255,100,0), SWEP.AttachModel, 2.5, nil, Angle(0,90,0))