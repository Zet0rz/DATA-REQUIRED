
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
local scale = 20

function ENT:Initialize()
	self:SetModel(model)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.ShooterSafeTime = CurTime() + 0.1
	
	--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	if SERVER then
		if not self.Size then self:RebuildPhysics(nil) end
		self:SetSpeed()
		self:SetTrigger(true)
		
		self.NoBulletHit = true
	end
end

function ENT:RebuildPhysics(value)
	local size = value or 1
	
	--self:PhysicsInitSphere(size2, "default_silent")
	--self:SetCollisionBounds(Vector(-size2, -size2, -size2), Vector(size2, size2, size2))
	self:SetModelScale(size)
	self:Activate()

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableGravity(false)
		phys:EnableDrag(false)
		phys:EnableMotion(true)
		
		phys:Wake()
	end
	
	self:SetBulletSize(size)
	self.Size = size
	self:SetTrigger(true)
	--debugoverlay.Sphere(self:GetPos(), size2)
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "BulletSize")
end

function ENT:SetCollideFunction(func)
	self.CollideFunc = func
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
	local mat = Material("SGM/playercircle")
	function ENT:Draw()
		--[[if not self.BulletScale or self.BulletScale ~= self:GetBulletSize() then
			local size = self:GetBulletSize()
			local vs = Vector(size*scale, size*scale, size*scale)
			local m = Matrix()
			m:Scale(vs)
			self:EnableMatrix("RenderMultiply", m)
			self.BulletScale = size
			print("Scaled to", size)
		end]]
		--self:DrawModel()
		
		local pos = self:GetPos()
		render.SetMaterial(mat)
		local size = self:GetBulletSize()*scale
		--render.DrawSprite(pos, size, size, Color(100,100,100))
		
		local s = self:GetBulletSize()/2
		--render.DrawBox(pos, Angle(0,0,0), Vector(-s,-s,-s), Vector(s,s,s), Color(255,255,255), false)
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
		print("touched", ent)
		self.Damage:SetDamagePosition(self:GetPos())
		self.Damage:SetDamageForce(self:GetVelocity())
		ent:TakeDamageInfo(self.Damage)
		
		if self.CollideFunc then self.CollideFunc(self, ent) end
		
		self:Remove()
	end
end

function ENT:SetAttacker(ent)
	self.Attacker = ent
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end