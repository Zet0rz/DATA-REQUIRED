local lifetime = 1 -- Time with total effect (rising particles)
local riseparticledelay = 0.01
local add = Vector(0,0,40)

local sound = Sound("ambient/levels/citadel/portal_beam_shoot5.wav")

function EFFECT:Init( data )

	self.Player = data:GetEntity()
	if self.Player == LocalPlayer() then
		self.Velocity = Vector(0,0,1000)
		self.Size = 20
		self.RiseDelay = 0.005
		self.KillTime = CurTime() + 4
	else
		self.Velocity = Vector(0,0,300)
		self.Size = 10
		self.RiseDelay = 0.01
		self.KillTime = CurTime() + lifetime
	end
	
	self.NextRiseParticle = CurTime()
	
	self.Emitter = ParticleEmitter( self.Player:GetPos() )
	self.Particles = {}
	
	self.Player:EmitSound(sound, 100)
	
	--print(self.Emitter, self.NextParticle, self, self.Player)
	
end

function EFFECT:Think()
	local ct = CurTime()
	if ct >= self.NextRiseParticle then
		local particle = self.Emitter:Add("sprites/glow04_noz", self.Player:GetPos() + Vector(math.Rand(-10,10), math.Rand(-10,10), 0))
		if (particle) then
			particle:SetVelocity( self.Velocity )
			particle:SetColor(math.random(100,150), math.random(200,255), math.random(100,150))
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 1 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( self.Size )
			particle:SetEndSize( self.Size )
			particle:SetRoll( math.Rand(0, 36)*10 )
			--particle:SetRollDelta( math.Rand(-200, 200) )
			particle:SetAirResistance( 10 )
			particle:SetGravity( Vector( 0, 0, 0 ) )
			
			self.NextRiseParticle = CurTime() + self.RiseDelay
		end
	end
	if self.KillTime < ct then
		return false
	else
		return true
	end
end

function EFFECT:Render()
	
end
