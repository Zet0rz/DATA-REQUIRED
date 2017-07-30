Msg("Init.lua loads!") 

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "player.lua" )
AddCSLuaFile( "weapon_pickups.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "scoring.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "f1_menu.lua" )

include( "shared.lua" )
include( "player.lua" )
include( "testchamber.lua" )
include( "weapon_pickups.lua" )
include( "ent_extend.lua" )
include( "scoring.lua" )
include( "f1_menu.lua" )

local playermodels = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_05.mdl",
	"models/player/group01/female_06.mdl",
	"models/player/group01/male_01.mdl",
	"models/player/group01/male_02.mdl",
	"models/player/group01/male_03.mdl",
	"models/player/group01/male_04.mdl",
	"models/player/group01/male_05.mdl",
	"models/player/group01/male_06.mdl",
	"models/player/group01/male_07.mdl",
	"models/player/group01/male_08.mdl",
	"models/player/group01/male_09.mdl"
}

-- Same as my colors from You Touched it Last
local playercolors = {
	-- Pure colors
	Vector(1, 0, 0), -- Red
	Vector(0, 1, 0), -- Green
	Vector(0, 0, 1), -- Blue
	
	-- Two 1's, one 0
	Vector(1, 1, 0), -- Yellow
	Vector(1, 0, 1), -- Purple
	Vector(0, 1, 1), -- Ice
	
	-- 0.5 Green
	Vector(1, 0.5, 0), -- Orange
	Vector(0, 0.5, 1), -- Sky
	Vector(1, 0.5, 1), -- Pink
	
	-- 0.5 Red
	Vector(0.5, 0, 1), -- Dark Purple
	Vector(0.5, 1, 0), -- Lime
	Vector(0.5, 1, 1), -- Bright Ice
	
	-- 0.5 Blue
	Vector(1, 0, 0.5), -- Rose
	Vector(0, 1, 0.5), -- Turquoise
	Vector(1, 1, 0.5), -- Lemon
}

local campos = Vector(0, 125, 1200)
util.AddNetworkString("dr_campos")

function GM:InitPostEntity()
	if Entity(0).RoundIdle == nil then Entity(0).RoundIdle = true end
end

function GM:PlayerInitialSpawn(ply)
	print("Spawned", ply)
	if #player.GetAll() >= 2 and Entity(0).RoundIdle then
		PrintMessage(HUD_PRINTTALK, "Test subject ["..ply:Nick().."] initiated. Testing will initiate in 5 seconds ...")
		timer.Simple(5, function()
			self:ResetTests()
			self:BeginRound()
		end)
		Entity(0).RoundIdle = false
	end
	
	net.Start("dr_campos")
		net.WriteVector(campos)
	net.Send(ply)
end

function GM:EntityRemoved(ent)
	if ent:IsPlayer() then
		if #player.GetAll() < 2 and not Entity(0).RoundIdle then
			PrintMessage(HUD_PRINTTALK, "Test subject ["..ent:Nick().."] terminated testing protocol. Test Environment entering Training Mode ...")
			
			
			net.Start("data_testcomplete")
				net.WriteUInt(self.RoundNumber, 8)
				local winner = team.GetPlayers(TEAM_TESTSUBJECTS)[1]
				if IsValid(winner) then
					winner:AddFrags(1)
					net.WriteBool(true)
					net.WriteEntity(winner)
					net.WriteBool(true)
				else
					net.WriteBool(false)
					net.WriteBool(true)
				end
			net.Broadcast()
			Entity(0).RoundIdle = true
		end
	end
end

local runspeed = 250
function GM:PlayerSpawn(ply)
	--ply:SetModel(table.Random(playermodels))
	ply:SetHealth(100)
	ply:SetWalkSpeed(runspeed)
	ply:SetRunSpeed(runspeed)
	
	if ply:Team() == TEAM_TESTSUBJECTS then
		local x,y = self:CalculateDesiredWeaponSpawnpoint()
		if x and y then
			ply:SetPos(GetGridCoordinateCenter(x,y) + Vector(0,0,150))
		end
	end
end


function GM:PostPlayerDeath(ply)
	if SERVER and self.RoundOngoing then
		self.CHECKPLAYERS = true
	end
end

util.AddNetworkString("data_killfeed")
function GM:PlayerDeath(victim, inflictor, attacker)
	net.Start("data_killfeed")
		net.WriteEntity(attacker)
		net.WriteEntity(victim)
		net.WriteString(IsValid(inflictor) and inflictor.WeaponClass or victim.DeathClass or "")
	net.Broadcast()
	
	victim:SetTeam(TEAM_DEAD)
end
function GM:PlayerDeathThink(ply)

end

function GM:BeginRound()
	self:CleanUp()
	self:LoadRandomMap()
	
	local e = EffectData()
	for k,v in pairs(player.GetAll()) do
		v:StripWeapons()
		v:SetModel(playermodels[math.random(#playermodels)])
		v:SetPlayerColor(playercolors[math.random(#playercolors)])
		v:SetTeam(TEAM_TESTSUBJECTS)
		v.Owner = nil -- You belong to yourself from spawn
		if IsValid(v.AttachedWeaponModel) then v.AttachedWeaponModel:Remove() end
		
		local x,y = self:CalculateDesiredWeaponSpawnpoint()
		v:Spawn()
		v:SetPos(GetGridCoordinateCenter(x,y) + Vector(0,0,150))
		
		v:Freeze(true)
		e:SetEntity(v)
		e:SetOrigin(v:GetPos())
		util.Effect("data_fx_spawn", e, true)
		
		local str = x..";"..y
		if self.WeaponGrid[str] == false then self.WeaponGrid[str] = true end
	end
	self:ResetWeaponGridList()
	self.RoundOngoing = true
	
	self:TestStart()
	
	local time = CurTime() + 3
	hook.Add("Think", "data_testunfreeze", function()
		if CurTime() > time then
			for k,v in pairs(team.GetPlayers(TEAM_TESTSUBJECTS)) do
				v:Freeze(false)
			end
			hook.Remove("Think", "data_testunfreeze")
		end
	end)
	
	--[[net.Start("dr_campos")
		net.WriteVector(campos)
	net.Broadcast()]]
end

local cleanents = {
	data_weaponpickup = true,
	data_projectile2 = true,
}
function GM:CleanUp()
	for k,v in pairs(ents.GetAll()) do
		if cleanents[v:GetClass()] or v.MapCleanup then v:Remove() end
	end
end

function GM:EndRound(ply)
	self.RoundOngoing = false	
	if IsValid(ply) then
		PrintMessage(HUD_PRINTTALK, ply:Nick() .. " won!")
		self:TestComplete(ply)
	else
		PrintMessage(HUD_PRINTTALK, "There were no winners!")
		self:TestComplete()
	end
end

function GM:BuildMapFromTable(index)	
	game.CleanUpMap()
	
end

function GM:PlayerHurt(ply, attacker, health, dmg)
	ply:Scream(health <= 0)
end

hook.Add("PlayerShouldTakeDamage", "data_playerinvulnerable", function(ply, att)
	--if ply.INVULNERABLE or att.Owner == ply then return false end
	if ply.INVULNERABLE then return false end
end)

function GetCamPos()
	return campos
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) then wep:Finish() end
	ply:CreateRagdoll()
	ply:AddDeaths(1)
	
	local typ = dmginfo:GetDamageType()
	if typ == DMG_BURN then
		local mdl = ply:GetRagdollEntity()
		--mdl:SetModel()
	end
	
	--[[if ( attacker:IsValid() && attacker:IsPlayer() ) then
		if ( attacker == ply ) then
			attacker:AddFrags(-1)
		else
			attacker:AddFrags(1)
		end
	end]]
end