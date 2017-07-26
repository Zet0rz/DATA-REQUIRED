
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Type = "anim"
ENT.PrintName		= "Missile"
ENT.Author			= "Zet0r"
ENT.Information		= "Let the gamemode spawn it"

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

ENT.MapCleanup = true

local model = "models/weapons/w_missile.mdl"
local explosionradius = 100

function ENT:Initialize()

	self:SetModel(model)
	
	if SERVER then
		--self:PhysicsInitShadow(true, true)
		--self:SetTrigger(true)
		--self:SetNotSolid(true)
	end
	self:StartMotionController()
end

function ENT:PhysicsCollide(data, obj)
	self:Explode()
end

local speed = 100
function ENT:PhysicsSimulate(phys, dt)
	print("Called")
	local pos = self:GetPos() + self:GetAngles():Forward()*speed
	local ang = self.Owner:GetAimVector():Angle()
	phys:UpdataShadow(pos, ang, dt)
end

function ENT:Explode()
	util.BlastDamage(self, self.Owner, self:GetPos(), explosionradius, 100)
	local e = EffectData()
	e:SetOrigin(self:GetPos())
	util.Effect("Explosion", e, true)
	util.ScreenShake(self:GetPos(), 5, 5, 1, 5000)
	self:Remove()
end