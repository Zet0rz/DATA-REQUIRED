
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "The head of the Laser Sniper projectile"
ENT.Author			= "Zet0r"
ENT.Information		= "The main objective"

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= true
ENT.RenderGroup		= RENDERGROUP_BOTH

ENT.MaxBounces		= 5
--ENT.MaxDistance		= 1000

local beammat = "cable/redlaser.vmt"
local beamdecaydelay = 0.5
local beamcolor = Color(255,0,0)

function ENT:Initialize()

	self:SetModel("models/props_junk/wood_crate001a.mdl")
	
	if SERVER then
		self.BounceCount = 0
		self.Distance = 0
		
		self:SetTrigger(true)
		self:SetNoDraw(true)
		self.trail_entity = util.SpriteTrail( self, 0, beamcolor, false, 100, 100, beamdecaydelay, 20, beammat )
	end
	
	self:PhysicsInitSphere( 5, "metal_bouncy" )
	--self:SetMoveType(MOVETYPE_FLY)
	--self:SetNotSolid(true)
	--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
end

if CLIENT then
	--local beammat = Material("models/effects/comball_tape.vmt")
	--local beammat = Material("models/effects/comball_sphere.vmt")
	--local beammat = Material("cable/xbeam")
	--local beammat = Material("cable/hydra")
	--local beammat = Material("cable/redlaser")
	
	
	function ENT:Draw()
		--[[if not self.LastDir then self.LastDir = Vector() end
		if not self.Bounces then self.Bounces = {} end
		local dir = self:GetAbsVelocity():GetNormalized()
		print(dir)
		
		if dir ~= self.LastDir then
			self.LastDir = dir
			table.insert(self.Bounces, {pos = self:GetPos(), time = CurTime()})
			print("Changed dir")
		end
		
		
		for k,v in pairs(self.Bounces) do
			if k < #self.Bounces then
				local startpos = v.pos
				local endpos = self.Bounces[k+1].pos
				render.SetMaterial(beammat)
				render.DrawBeam(startpos, endpos, 20, 0, 1, beamcolor)
			end
		end]]
		
		self:DrawModel()
		
	end
end

function ENT:OnRemove()
	
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		local d = DamageInfo()
		d:SetDamage(100)
		d:SetDamageType(DMG_DISSOLVE)
		d:SetAttacker(self.Owner)
		d:SetInflictor(self)
		ent:TakeDamageInfo(d)
		
		self:Dissipate()
	end
end

function ENT:PhysicsCollide(data, physobj)
	self.BounceCount = self.BounceCount + 1
	if self.BounceCount > self.MaxBounces then 
		self:Dissipate()
	end
end

function ENT:Dissipate()
	self:SetVelocity(Vector(0,0,0))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetNotSolid(true)
	timer.Simple(beamdecaydelay + 0.5, function()
		if IsValid(self) then self:Remove() end
	end)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end