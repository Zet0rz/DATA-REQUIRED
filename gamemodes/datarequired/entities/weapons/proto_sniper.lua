if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Sniper Rifle"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Instantly fry any enemy in a line in front of you"
SWEP.Instructions	= "LMB to fire - Has to charge up where you can't move!"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "pistol"

SWEP.AttachModel = "models/combine_turrets/combine_cannon_stand.mdl"
SWEP.AttachScale = 0.5
SWEP.AttachOffset = Vector(-30,0,-20)
SWEP.AttachAngle = Angle(0,-90,0)

local chargetime = 0.5
local removedelay = 1
local hullsize = 15

local chargesound = Sound("weapons/physcannon/physcannon_charge.wav")
local shootsound = {
	Sound("weapons/physcannon/energy_disintegrate4.wav"),
	Sound("weapons/physcannon/energy_disintegrate5.wav")
}

function SWEP:SetupDataTables()
	self:NetworkVar("Vector", 0, "StartPos")
	self:NetworkVar("Vector", 1, "EndPos")
	self:NetworkVar("Bool", 0, "Fired")
end

function SWEP:PrimaryAttack()
	if SERVER then
		if not self.Fired then
			self.Owner:EmitSound(chargesound)
			self:SetHoldType("crossbow")
			self.Owner:Freeze(true)
			self.Fired = CurTime() + chargetime
		end
	end
end

function SWEP:Think()
	if self.Fired and not self.TOKILL and self.Fired < CurTime() then
		local dir = self.Owner:GetAimVector()
	
		local hitplayers = {}
		local start = self.Owner:GetShootPos()
		local endpos = start + dir*10000
		local trace = {
			start = start,
			endpos = endpos,
			filter = function(ent) return ent ~= self.Owner and (ent:IsPlayer() or ent:IsWorld()) and not hitplayers[ent] end,
			mins = Vector(-hullsize, -hullsize, -hullsize),
			maxs = Vector(hullsize, hullsize, hullsize),
			mask = MASK_SHOT
		}
		
		local tr = util.TraceHull(trace)
		while tr.Entity:IsPlayer() do
			hitplayers[tr.Entity] = true
			trace.start = tr.HitPos
			trace.endpos = trace.start + dir*10000
			
			tr = util.TraceHull(trace)
		end
		
		self:SetStartPos(start)
		self:SetEndPos(tr.HitPos)
		self:SetFired(true)
		
		local d = DamageInfo()
		d:SetDamage(100)
		d:SetDamageType(DMG_DISSOLVE)
		d:SetAttacker(self.Owner)
		d:SetInflictor(self)
		
		for k,v in pairs(hitplayers) do
			k:TakeDamageInfo(d)
		end
	
		self.Owner:EmitSound(shootsound[math.random(#shootsound)])
		self.TOKILL = CurTime() + removedelay
	end
	if self.TOKILL and self.TOKILL < CurTime() then
		self.Owner:Freeze(false)
		self:Finish()
	end
end

if CLIENT then
	local beammat = Material("cable/hydra.vmt")
	local beamsize = 100
	local col = Color(200,255,100)
	function SWEP:PrePlayerDraw(ply)
		if self:GetFired() then
			local pos = self:GetStartPos()
			local pos2 = self:GetEndPos()
			local ct = CurTime()
			if not self.Decaytime then self.Decaytime = ct + removedelay end
			render.SetMaterial(beammat)
			local diff = self.Decaytime-ct
			render.DrawBeam(pos, pos2, (diff)/removedelay*beamsize+math.random(0,30), diff,diff+1,col)
		end
	end
end

GAMEMODE:AddWeaponPickup("proto_sniper", 90, Color(200,255,100), SWEP.AttachModel, 0.75, Vector(0,-20,0))