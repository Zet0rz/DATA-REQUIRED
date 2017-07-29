if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Nuke"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Call a Shield and Nuke"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "pistol"

SWEP.AttachModel = "models/effects/intro_vortshield.mdl"
SWEP.AttachScale = 1
SWEP.AttachAngle = Angle(90,0,0)

local nukemdl = "models/props_phx/ww2bomb.mdl"

local delay = 4
local shieldsize = 1000
local radius = (shieldsize/2)^2
SWEP.Instructions = "Click to place Shield - Nuke kills anyone outside after "..delay.." seconds"

function SWEP:PrimaryAttack()
	if SERVER and not self.Fired then
		local shield = self:CreateEntity("data_shield")
		shield:SetSize(shieldsize)
		shield:SetPos(self.Owner:GetPos())
		shield:Spawn()
		self.Fired = true
		
		local ply = self.Owner
		
		timer.Simple(1, function() local dir = (ply:GetPos()-shield:GetPos()):GetNormalized()
		local e = EffectData()
		e:SetOrigin(shield:GetPos() + dir*math.sqrt(radius))
		util.Effect("Explosion", e, true) end)
		
		local nuke = self:CreateEntity("data_airstrike")
		nuke:SetPos(GetGridCoordinateCenter(7,4))
		nuke:Spawn()
		nuke:SetExplodeFunction(function(self2)
			local d = DamageInfo()
			d:SetDamageType(DMG_BURN)
			d:SetDamage(100)
			d:SetInflictor(self2)
			d:SetAttacker(ply)
			for k,v in pairs(player.GetAll()) do
				if not shield:PlayerIsWithin(v) then
					v:TakeDamageInfo(d)
				end
			end
			
			local e = EffectData()
			e:SetOrigin(self2:GetPos())
			util.Effect("data_fx_nuke", e, true)
			util.ScreenShake(self2:GetPos(), 50, 50, 1, 10000)
			self2:EmitSound("datarequired/nuke_explosion.wav")
			self2:Remove()
		end)
		nuke:EmitSound("datarequired/nuke_countdown.wav")
		
		timer.Simple(delay, function()
			if IsValid(nuke) then
				nuke:SetLocalVelocity(Vector(0,0,-1500))
				nuke:SetModel(nukemdl)
				nuke:Drop(3)
			end
		end)
		
		timer.Simple(delay + 3.5, function()
			if IsValid(nuke) then nuke:Remove() end
			if IsValid(shield) then shield:Remove() end
		end)
		self:Finish()
	end
end

function SWEP:Think()
	
end

GAMEMODE:AddWeaponPickup("proto_nuke", 25, Color(50,50,50), SWEP.AttachModel, 1, nil, Angle(90,0,0))