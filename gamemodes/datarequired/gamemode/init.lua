Msg("Init.lua loads!") 

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "player.lua" )
AddCSLuaFile( "weapon_pickups.lua" )
--AddCSLuaFile( "ent_extend.lua" )

include( "shared.lua" )
include( "player.lua" )
include( "testchamber.lua" )
include( "weapon_pickups.lua" )
include( "ent_extend.lua" )

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

local mapdata = {
	["mb_melonbomber"] = {
		cam = Vector(),
		spawns = {
			Vector(0,0,-380),
			Vector(120,0,-380),
			Vector(-120,0,-380),
			Vector(0,150,-380),
			Vector(0,-150,-380),
			Vector(120,150,-380),
			Vector(-120,150,-380),
			Vector(120,-150,-380),
			Vector(-120,-150,-380),
		},
	},
}

local campos = Vector(0, 125, 1200)
util.AddNetworkString("dr_campos")

function GM:PlayerInitialSpawn(ply)
	if #player.GetAll() <= 2 then
		--self:BeginRound()
	end
	
	net.Start("dr_campos")
		net.WriteVector(campos)
	net.Send(ply)
end

function GM:PlayerSpawn(ply)
	ply:SetModel(table.Random(playermodels))
	ply:SetHealth(1)
	
	local x,y = self:CalculateDesiredWeaponSpawnpoint()
	if x and y then
		ply:SetPos(GetGridCoordinateCenter(x,y))
	end
end

function GM:PlayerDeath(ply)
	
end


function GM:BeginRound()
	for k,v in pairs(player.GetAll()) do
		v:SetModel(table.Random(playermodels))
		v:SetPlayerColor(ColorToVector(team.GetColor(v:Team())))
	end
	
	campos = mapdata[game.GetMap()] and mapdata[game.GetMap()].cam or Vector()
	
	net.Start("dr_campos")
		net.WriteVector(campos)
	net.Broadcast()
end

function GM:RoundEnded(winteam)
	
end

function GM:BuildMapFromTable(index)	
	game.CleanUpMap()
	
end