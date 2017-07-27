if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Cloak & Dagger"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Go invisible for 5 seconds and melee people to death"
SWEP.Instructions	= "Press LMB to go invisible - While invisible press LMB to swing"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "normal"

local model = "models/weapons/w_crowbar.mdl"
SWEP.WorldModel = model
local time = 5
local reach = 100
local size = 15
local delay = 0.5

local cloaksound = Sound("weapons/physcannon/physcannon_drop.wav")
local swingsound = Sound("weapons/iceaxe/iceaxe_swing1.wav")
local hitsounds = {
	Sound("physics/flesh/flesh_impact_bullet1.wav"),
	Sound("physics/flesh/flesh_impact_bullet2.wav"),
	Sound("physics/flesh/flesh_impact_bullet3.wav"),
	Sound("physics/flesh/flesh_impact_bullet4.wav"),
	Sound("physics/flesh/flesh_impact_bullet5.wav"),
}

function SWEP:PrimaryAttack()	
	if not self:GetOn() then
		self:SetHoldType("melee")
		self:SetOn(true)
		self.Owner:EmitSound(cloaksound)
		if SERVER then self.EndTime = CurTime() + time end
		self.NextAttack = CurTime() + delay
	elseif CurTime() > self.NextAttack then
		self.Owner:DoAttackEvent()
		self:EmitSound(swingsound)
		if SERVER then
			local spos = self.Owner:GetShootPos()
			local ent = self.Owner:TraceHullAttack(spos, spos + self.Owner:GetAimVector()*reach, Vector(-size,-size,-size), Vector(size,size,size), 100, DMG_CLUB, 100, false)
			if IsValid(ent) and ent:IsPlayer() then
				ent:EmitSound(hitsounds[math.random(#hitsounds)])
			end
		end
		self.NextAttack = CurTime() + delay
	end
end

function SWEP:Think()
	if self.EndTime and CurTime() > self.EndTime then
		self:Finish()
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 1, "On")
end

function SWEP:PrePlayerDraw(ply)
	if self:GetOn() then
		if ply == LocalPlayer() then
			render.SetColorModulation(0.1,0.1,0.1)
			ply:DrawModel()
			render.SetColorModulation(1,1,1)
		end
		return true
	end
end

GAMEMODE:AddWeaponPickup("proto_cloakanddagger", 100, Color(0,0,0), model, 1.5)