
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Mine"
ENT.Author			= "Zet0r"
ENT.Information		= "Let the gamemode spawn it"

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

local model = "models/props_combine/combine_mine01.mdl"
local fragmentsize = 10
local fragmentspeed = 400
local numfragments = 30

local armsound = Sound("npc/roller/mine/rmine_blip1.wav")
local triggersound = Sound("npc/roller/mine/rmine_blip3.wav")
local explodesound = Sound("npc/roller/mine/rmine_explode_shock1.wav")

ENT.MapCleanup = true

function ENT:Initialize()

	self:SetModel(model)
	
	if SERVER then
		self:PhysicsInitSphere(64, "default_silent")
		self:SetTrigger(true)
		self:SetNotSolid(true)
		self.ArmTime = CurTime() + 1
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() and self.Armed then
		self.ExplodeTime = CurTime() + 0.25
		self:SetNoDraw(false)
		self:EmitSound(triggersound, 511)
	end
end

function ENT:Think()
	if self.ExplodeTime and self.ExplodeTime < CurTime() then
		self:Explode()
	end
	if not self.Armed and self.ArmTime and self.ArmTime < CurTime() then
		self:SetNoDraw(true)
		self:EmitSound(armsound, 511)
		self.Armed = true
	end
end

function ENT:Explode()
	local d = DamageInfo()
	d:SetDamage(100)
	d:SetDamageType(DMG_BULLET)
	d:SetAttacker(self.Owner)
	d:SetInflictor(self)
	self:EmitSound(explodesound, 511)
	
	local pos = self:GetPos() + Vector(0,0,10)
	for i = 1, numfragments do
		local vel = Angle(0,360/numfragments*i,0):Forward()*fragmentspeed
		self:FireProjectile(fragmentsize, pos, vel, d)
	end
	self:Remove()
end