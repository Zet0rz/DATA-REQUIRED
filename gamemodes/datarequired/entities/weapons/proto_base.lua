if SERVER then
	AddCSLuaFile()
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= true
	SWEP.AutoSwitchFrom	= false	
end

if CLIENT then

	SWEP.PrintName     	    = "Prototype Base"			
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true

end

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "A base for all Prototype-level weapons"
SWEP.Instructions	= "Let the gamemode give you it"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.HoldType = "normal"

SWEP.ViewModel	= "models/weapons/c_grenade.mdl"
SWEP.WorldModel	= "models/weapons/w_grenade.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

-- Data for weapon spawner
SWEP.PickupModel			= ""
SWEP.PickupColor			= Color(255,0,0)
SWEP.PickupModelScale		= 1

-- Data for attaching model to hand (custom weapon models basically)
SWEP.AttachScale			= 1

function SWEP:Initialize()
	--self:CreateAttachedModel()
end

function SWEP:CreateAttachedModel()
	if not IsValid(self.Owner.AttachedWeaponModel) and SERVER then
		print("Created", self.Owner)
		local mdl = ents.Create("data_weaponattachment")
		mdl:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		mdl:SetModel("models/props_junk/wood_crate001a.mdl")
		mdl:SetNoDraw(true)
		mdl:SetNotSolid(true)
		mdl:Spawn()
		
		-- Attach to hand?
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		mdl:FollowBone(self.Owner, bone)
		mdl:SetPos(self.Owner:GetBonePosition(bone))
		
		self.Owner.AttachedWeaponModel = mdl
	end
end

function SWEP:Deploy()
	self:CreateAttachedModel()
	if self.AttachModel then -- Optional, using weapon world model is preferred
		local mdl = self.Owner.AttachedWeaponModel
		if mdl then
			mdl:SetNoDraw(false)
			mdl:SetModel(self.AttachModel)
			mdl:SetModelScale(self.AttachScale)
		end
		-- Merge with handbone
	else
		self.Owner.AttachedWeaponModel:SetNoDraw(true)
	end
end

function SWEP:PrimaryAttack()
	
end

function SWEP:SecondaryAttack()
	
end

-- Finish using SWEP, call after SWEP should be unequipped
function SWEP:Finish()
	if IsValid(self.Owner.AttachedWeaponModel) then
		self.Owner.AttachedWeaponModel:SetNoDraw(true)
		self.Owner:StripWeapon(self:GetClass())
	end
end

function SWEP:DrawHUD()
	
end


function SWEP:Reload()
	-- Drop logic?
end

function SWEP:OnRemove()
	local mdl = self.Owner.AttachedWeaponModel
	if mdl then
		mdl:SetNoDraw(true)
	end
end