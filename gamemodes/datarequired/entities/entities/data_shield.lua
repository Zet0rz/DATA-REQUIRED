
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Shield"
ENT.Author			= "Zet0r"
ENT.Information		= "Just looks cool really ..."

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

local shieldmodel = "models/Combine_Helicopter/helicopter_bomb01.mdl"
local shieldmat = "models/effects/vortshield.vmt"

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Size")
end

function ENT:Initialize()
	if CLIENT then return end
	
	self:SetNotSolid(true)
	self:SetModel(shieldmodel)
	self:SetMaterial(shieldmat, true)
	self:SetModelScale(self:GetSize()/40)
end

if CLIENT then
	local mat = Material("SGM/playercircle")
	local col = Color(0,255,0,10)
	local shieldmat2 = Material(shieldmat)
	function ENT:Draw()
		local pos = self:GetPos()
		render.SetMaterial(mat)
		local size = self:GetSize()
		local size2 = size*1.25
		render.DrawQuadEasy(pos, Vector(0, 0, 1), size2, size2, col, 0)
		render.SetMaterial(shieldmat2)
		--render.SetColorMaterial()
		render.DrawSphere(pos, size/2, 50, 50, col)
		--self:DrawModel()
	end
else
	function ENT:Think()
		--if self.TOKILL then self:Remove() end
	end
end

function ENT:OnRemove()
	
end

function ENT:PlayerIsWithin(ply)
	return ply:GetPos():DistToSqr(self:GetPos()) <= (self:GetSize()/2)^2
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end