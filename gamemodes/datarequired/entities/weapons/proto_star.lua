if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Star"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Instructions	= "Run into people to kill them!"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "normal"

SWEP.WorldModel = "models/balloons/balloon_star.mdl"

local time = 5
SWEP.Purpose		= "You are invulnerable for "..time.." seconds!"

sound.Add({
	name = "dreq_star",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 511,
	pitch = {100},
	sound = "datarequired/mario_star.wav"
})
local soundtime = SoundDuration("datarequired/mario_star.wav") - 0.05

function SWEP:OnDeploy()
	self.TOKILL = CurTime() + time
	self.Owner:SetCustomCollisionCheck(true)
	self.Owner.INVULNERABLE = true
	self.OldSpeed = self.Owner:GetWalkSpeed()
	self.Owner:SetWalkSpeed(self.OldSpeed*1.3)
	self.Owner:SetRunSpeed(self.OldSpeed*1.3)
	
	self.NextStarSound = CurTime()
end

function SWEP:Think()
	if SERVER then
		if self.TOKILL and self.TOKILL < CurTime() then
			self.Owner.INVULNERABLE = false
			self.Owner:SetWalkSpeed(self.OldSpeed)
			self.Owner:SetRunSpeed(self.OldSpeed)
			self.Owner:StopSound("dreq_star")
			self:Finish()
		end
		if self.NextStarSound and self.NextStarSound < CurTime() then
			self.Owner:EmitSound("dreq_star")
			self.NextStarSound = CurTime() + soundtime
		end
	end
end

local maxdist = 60^2
function SWEP:ShouldCollide(ply, ent)
	if SERVER and ent:IsPlayer() and ent:Alive() and ent:GetPos():DistToSqr(ply:GetPos()) <= maxdist then
		local d = DamageInfo()
		d:SetDamage(100)
		d:SetDamageType(DMG_DISSOLVE)
		d:SetAttacker(self.Owner)
		d:SetInflictor(self)
		
		ent:TakeDamageInfo(d)
	end
end

if CLIENT then
	local fadespeed = 100
	local curcolor = 0
	function SWEP:PrePlayerDraw(ply)
		curcolor = (curcolor + fadespeed*FrameTime())%360
		local col = HSVToColor(curcolor, 1,1)
		render.SetColorModulation(col.r,col.g,col.b)
		ply:DrawModel()
		render.SetColorModulation(1,1,1)
		return true
	end
end

GAMEMODE:AddWeaponPickup("proto_star", 40, Color(255,255,0), SWEP.WorldModel, 2, Vector(-15,0,0), Angle(90,0,0))