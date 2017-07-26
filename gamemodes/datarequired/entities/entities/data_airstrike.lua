
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Type = "anim"
ENT.PrintName		= "Airstrike Missile"
ENT.Author			= "Zet0r"
ENT.Information		= "Let the gamemode spawn it"

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

ENT.MapCleanup = true

local model = "models/weapons/w_missile.mdl"
local explosionradius = 300

local launchsound = Sound("thrusters/hover00.wav")
local explosionsound = Sound("phx/explode00.wav")

function ENT:Initialize()
	self:SetModel(model)
	
	self.TargetPos = self:GetPos()
	self:SetPos(Vector(0, 500, 1500))
	
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_FLY)
	self:SetModelScale(3)
	self:SetAngles(Angle(90,0,0))
	--self:EmitSound(launchsound)
end

function ENT:Drop(time)
	local time = time or 3
	local dir = (self.TargetPos-self:GetPos())/time
	
	self:SetLocalVelocity(dir)
	self:SetAngles(dir:Angle())
	
	timer.Simple(time, function()
		if IsValid(self) then self:Explode() end
	end)
end

function ENT:SetExplodeFunction(func)
	self.ExplodeFunc = func
end

function ENT:Explode()
	if self.ExplodeFunc then self:ExplodeFunc() return end
	
	util.BlastDamage(self, self.Owner, self.TargetPos, explosionradius, 300)
	
	local e = EffectData()
	e:SetOrigin(self.TargetPos)
	util.Effect("Explosion", e, true)
	util.ScreenShake(self.TargetPos, 50, 50, 1, 10000)
	
	self:EmitSound(explosionsound)
	self:Remove()
end