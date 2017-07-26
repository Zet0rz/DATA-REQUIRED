
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
		
		local mdl = ents.Create("data_weaponattachment")
		mdl:SetPos(self:GetPos())
		mdl:Spawn()
		mdl:SetParent(self)
		self:SetModelEntity(mdl)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 1, "Weapon")
	self:NetworkVar("Entity", 1, "ModelEntity")
end

function ENT:SetWeaponPickup(class)
	self:SetWeapon(class)
	local tbl = GAMEMODE:GetWeaponPickup(class)
	if tbl then
		--PrintTable(tbl)
		local mdl = self:GetModelEntity()
		mdl:SetModel(tbl.model)
		mdl:SetModelScale(tbl.scale)
		if tbl.angle then mdl:SetLocalAngles(tbl.angle) end
		if tbl.offset then mdl:SetLocalPos(tbl.offset) end
	end
end

if CLIENT then
	
	local mat = Material("SGM/playercircle")
	local rotspeed = Angle(0,10,0)
	function ENT:Draw()
		local data = GAMEMODE:GetWeaponPickup(self:GetWeapon())
		local col = data.color
		local mdl = self:GetModelEntity()
		if IsValid(mdl) then
			render.SetMaterial(mat)
			render.DrawQuadEasy(self:GetPos(), Vector(0, 0, 1), 64, 64, col, 0)
			
			mdl:DrawModel()
			
			--if !mdl:GetRenderAngles() then mdl:SetRenderAngles(mdl:GetAngles()) end
			self:SetAngles(self:GetAngles()+(rotspeed*FrameTime()))
		end
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

function ENT:OnRemove()
	if SERVER and IsValid(self:GetModelEntity()) then
		self:GetModelEntity():Remove()
	end
end