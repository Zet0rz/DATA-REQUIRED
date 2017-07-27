print("Shared Loads")

GM.Name = "[DATA REQUIRED]"
GM.Author = "Zet0r"
GM.Email = "N/A"
GM.Website = "https://youtube.com/Zet0r"

--[[		THINGS TO DO		--
	
	✓ 	 = Done
	-	 = Not Done
	?	 = Needs Testing
	X	 = Decided not to implement
	/	 = Couldn't do
	*	 = Partially done

	Submission Ready:
	✓	Top-down movement system
	✓	Camera positioning system
	✓	Weapon spawn systen
	✓	Player spawn system (Don't spawn on same tiles)
	✓	Death handling
	✓	Round restart/end functions
	✓	Projectile entity
	✓	Point/Score Management, actual winning
	✓	Death/Hurt sounds
	✓	Arena wall delays
	✓	Player freeze during start (while arena builds)
	✓	Weapon pickup angle and offsets
	*	Screenshake alternative (so death screen is not so weird)
	✓	Weapon changes (weighted random)
	✓	Logo and menu icon, workshop logo
	✓	Bullet bounce on some weapons
	-	F1 menu for map editing
	-	More maps
	-	Weapon balancing
	-	Killfeed
	-	Actual round starting (without having to lua_run it)
	
	Weapon idea list:
	#	Lua	Fx	Description
	1	✓	✓	Bouncing laser (Bounces on players)
	2	✓	*	Invisible mine
	3	*	✓	Cloak and Dagger (Invisibility + melee)
	4	*	*	Remote missile (Control with mouse)
	5	✓	✓	Shotgun (moving projectiles)
	6	✓	✓	Gatling (many slower moving projectiles)
	7	✓	✓	Melonbomb (blow up whole row + column, reference to Melonbomber)
	8	✓	*	Rainbow star (invulnerable, kill anyone on contact, Mario reference)
	9	-	-	Block remover (removes a block or wall from the grid)
	10	✓	✓	Fragment Bomb (Slow projectile, click again to blow up into many small fragment projectiles)
	11	-	-	Wave (Moves along grid, taking random turns for X grid movements)
	12	-	-	Napalm (Set a grid on fire for some time)
	13	-	-	Smoke grenade (Can't kill but can conceal an area)
	14	✓	✓	Sniper (Small buildup no move, laser through anything)
	15	✓	✓	Airstrike (Missile from above, global range)
	16	-	-	Gravity gun (Throw a toilet at someone)
	17	-	-	Flamethrower (Damage over time, AoE flame ahead of you)
	18	✓	✓	Turret (WILL target owner too!, low damage faster projectiles)
	19	✓	✓	Nuke + Shield (Kills anyone outside a large zone some time after use)
	20	*	-	Genji Dash (I NEED HEALING!!!)
	21	-	-	Bouncing sawblade?
	22	-	-	Flashbang?
	23	*	-	Rez (Revives a dead player who fights for your win, cannot hurt you, can die again)
	
	Possible
	-	Playermodels and color from sandbox?
	-	Color fade of arena?
	-	Music intensity based on weaponry usage?
	-	Faster gameplay? (aim for shorter rounds)
	-	Ping effect to prevent hiding?
	
	Bugs:
	-	Weapon models sometimes attaching to opposite hand? (On spawn changes hands, model change?)
	-	weapon:EmitSound not working serverside in multiplayer?
	-	Weapon attachments not disappearing on death
	-	Laser killing yourself
	-	Some weapon models are errors (Fragment, sniper, gatling, nuke shield)
	-	Scoreboard doesn't get smalle on removal of player
	-	Fragment bomb erroring if owner dies first (weapon no longer valid, PrimaryAttack)
	
]]

if not ConVarExists("dreq_maxwins") then CreateConVar("dreq_maxwins", 10, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "The amount of wins a player needs to win the game and reset all scores.") end

function ColorToVector( color )
	return Vector(color.r/255, color.g/255, color.b/255)
end

local camangle = Angle(0,90,0)
function GM:SetupMove(ply, mv, cmd)
	mv:SetMoveAngles(camangle)
end

TEAM_TESTSUBJECTS = 1
TEAM_DEAD = 2
team.SetUp(TEAM_TESTSUBJECTS, "Test Subjects", Color(150,150,255))
team.SetUp(TEAM_DEAD, "Test Subjects", Color(150,150,255)) -- Only meant to be used internally
team.SetUp(TEAM_SPECTATOR, "Spectator", Color(100,100,100))

hook.Add("ShouldCollide", "data_collide", function(ply, ent)
	if ply:IsPlayer() then
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep.ShouldCollide then
			return wep:ShouldCollide(ply, ent)
		end
	end
end)

function GM:PlayerNoClip(ply, state)
	return true
end