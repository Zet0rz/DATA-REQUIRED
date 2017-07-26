
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Mine"
ENT.Author			= "Zet0r"
ENT.Information		= "Let the gamemode spawn it"

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

local model = "models/airboatgun.mdl"
local updatetime = 0.5
local firerate = 0.1

local size = 10
local vel = 200

local armsound = Sound("npc/roller/mine/rmine_blip1.wav")
local shootsound = Sound("weapons/ar2/fire1.wav")

ENT.MapCleanup = true

function ENT:Initialize()

	self:SetModel(model)
	
	if SERVER then
		--self:PhysicsInitSphere(64, "default_silent")
		--self:SetTrigger(true)
		self:SetNotSolid(true)
		self.ArmTime = CurTime() + 1
		self.NextTargetCheck = CurTime() + updatetime
		self.NextFire = CurTime() + firerate
	end
end

function ENT:Think()
	if CLIENT then return end
	
	if self.ExplodeTime and self.ExplodeTime < CurTime() then
		self:Explode()
	end
	if not self.Armed and self.ArmTime and self.ArmTime < CurTime() then
		self:EmitSound(armsound, 511)
		self.Armed = true
		self.ArmTime = nil
		self.ExplodeTime = CurTime() + (self.Duration or 10)
	else
		if self.NextTargetCheck < CurTime() then
			self.Target = self:GetPriorityTarget()
		end
		
		if self.NextFire < CurTime() and self:HasValidTarget() then
			local dir = (self.Target:GetPos() - self:GetPos()):GetNormalized()
			self:SetAngles(dir:Angle())
			self:FireProjectile(size, self:GetPos()+dir*10, dir*vel, self.Damage)
			self:EmitSound(shootsound)
			self.NextFire = CurTime() + firerate
		end
	end
end

function ENT:GetPriorityTarget()
	self.NextTargetCheck = CurTime() + updatetime

	local pos = self:GetPos()
	local closest = self.Range
	local pclosest
	for _k,v in pairs(player.GetAll()) do
		if v:Alive() and v:Team() == TEAM_TESTSUBJECTS then
			local dist = v:GetPos():DistToSqr(pos)
			if dist <= closest and v:Visible(self) then
				closest = dist
				pclosest = v
			end
		end
	end

	return pclosest
end

function ENT:HasValidTarget()
	return IsValid(self.Target)
end

function ENT:SetDamage(dmg)
	self.Damage = dmg
end

function ENT:SetDuration(time)
	self.Duration = time
end

function ENT:SetRange(range)
	self.Range = range^2
end

function ENT:Explode()
	local e = EffectData()
	e:SetOrigin(self:GetPos())
	util.Effect("Explosion", e, true)
	self:Remove()
end