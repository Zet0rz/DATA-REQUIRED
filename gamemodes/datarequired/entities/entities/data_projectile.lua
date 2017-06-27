
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Projectile"
ENT.Author			= "Zet0r"
ENT.Information		= "A bullet projectile that travels slowly"

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

local model = "models/props_phx/cannonball.mdl"
local scale = 0.05

function ENT:Initialize()
	self:SetModel(model)
	self:DrawShadow(false)
	
	--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	if SERVER then
		if not self.Size then self:RebuildPhysics(nil) end
		self:SetSpeed()
	end
end

function ENT:RebuildPhysics( value )	
	local size = value or 2
	self:PhysicsInitSphere( size, "default_silent" )
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableGravity(false)
		phys:EnableDrag(false)
		phys:EnableMotion(true)
		
		phys:Wake()
	end
	
	self:SetModelScale(scale*size)
	self.Size = size
end

function ENT:SetSize(size)
	self:RebuildPhysics(size)
end
function ENT:SetDamage(damage)
	self.Damage = damage
end
function ENT:SetSpeed(speed)
	self.Speed = speed or 100
end

function ENT:SetSpeedVector(vel)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(vel)
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
else
	function ENT:Think()
		if self.TOKILL then self:Remove() end
	end
end

function ENT:OnRemove()
	
end

function ENT:PhysicsCollide(data, physobj)
	local ent = data.HitEntity
	if IsValid(ent) then
		self.Damage:SetDamagePosition(data.HitPos)
		self.Damage:SetDamageForce(data.OurOldVelocity)
		ent:TakeDamageInfo(self.Damage)
	end
	self.TOKILL = true
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end