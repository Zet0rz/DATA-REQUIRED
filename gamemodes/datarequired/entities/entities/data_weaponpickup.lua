
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "A weapon pickup that spawns randomly"
ENT.Author			= "Zet0r"
ENT.Information		= "Let the gamemode spawn it"

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

function ENT:Initialize()

	--self:SetModel("models/props_junk/wood_crate001a.mdl")
	
	if SERVER then
		self:PhysicsInitSphere(64, "default_silent")
		self:SetTrigger(true)
		self:SetNotSolid(true)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 1, "Weapon")
end

function ENT:SetWeaponPickup(class)
	self:SetWeapon(class)
	local tbl = GAMEMODE:GetWeaponPickup(class)
	if tbl then
		PrintTable(tbl)
		self:SetModel(tbl.model)
		self:SetModelScale(tbl.scale)
	end
end

if CLIENT then
	
	local mat = Material("SGM/playercircle")
	local rotspeed = Angle(0,10,0)
	function ENT:Draw()
		local col = GAMEMODE:GetWeaponPickup(self:GetWeapon()).color
		render.SetMaterial(mat)
		render.DrawQuadEasy(self:GetPos(), Vector(0, 0, 1), 64, 64, col, 0)
		
		self:DrawModel()
		
		if !self:GetRenderAngles() then self:SetRenderAngles(self:GetAngles()) end
		self:SetRenderAngles(self:GetRenderAngles()+(rotspeed*FrameTime()))
		
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() and not IsValid(ent:GetActiveWeapon()) then
		ent:Give(self:GetWeapon())
		ent:EmitSound("items/ammo_pickup.wav")
		self:Remove()
		
		if self.GridString then
			if GAMEMODE.WeaponGrid[self.GridString] then GAMEMODE.WeaponGrid[self.GridString] = false end
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end