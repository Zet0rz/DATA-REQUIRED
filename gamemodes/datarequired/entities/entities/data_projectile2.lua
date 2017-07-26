
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Projectile"
ENT.Author			= "Zet0r"
ENT.Information		= "A bullet projectile that travels slowly"

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

local model = "models/Combine_Helicopter/helicopter_bomb01.mdl"
local scale = 20

ENT.MaxBounces = 1

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Size")
end

function ENT:Initialize()
	if CLIENT then return end
	
	self:SetModel(model)
	self:RebuildPhysics()
	self:SetTrigger(true)
	self.ShooterSafeTime = CurTime() + 0.1
	self.NoBulletHit = true
	self.Bounces = 0
end

function ENT:RebuildPhysics()
	local size = self:GetSize() / 10
	self:PhysicsInitSphere( size, "metal_bouncy" )
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )

	--self:PhysWake()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(true)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:Wake()
	end
end

function ENT:SetCollideFunction(func)
	self.CollideFunc = func
end

function ENT:SetDamage(damage)
	self.Damage = damage
end

function ENT:SetSpeedVector(vel)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(vel)
	end
end

if CLIENT then
	local mat = Material("SGM/playercircle")
	function ENT:Draw()
		local pos = self:GetPos()
		render.SetMaterial(mat)
		local size = self:GetSize()
		render.DrawSprite(pos, size, size, Color(100,100,100))
	end
else
	function ENT:Think()
		if self.TOKILL then self:Remove() end
	end
end

function ENT:OnRemove()
	
end

function ENT:StartTouch(ent)
	if ent:CreatedByMap() or (not ent.NoBulletHit and (ent != self.Attacker or CurTime() > self.ShooterSafeTime)) then
		self.Damage:SetDamagePosition(self:GetPos())
		self.Damage:SetDamageForce(self:GetVelocity())
		ent:TakeDamageInfo(self.Damage)
		
		if self.Bounces >= self.MaxBounces and (not self.CollideFunc or not self:CollideFunc(ent)) then self:Remove() else self.Bounces = self.Bounces + 1 end
	end
end

function ENT:PhysicsCollide(data, obj)
	if data.HitEntity:IsWorld() then
		if self.Bounces >= self.MaxBounces and (not self.CollideFunc or not self:CollideFunc(data.HitEntity)) then self.TOKILL = true else self.Bounces = self.Bounces + 1 end
	end
end

function ENT:SetAttacker(ent)
	self.Attacker = ent
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end