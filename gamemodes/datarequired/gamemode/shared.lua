print("Shared Loads")
--[[		THINGS TO DO		--
	
	✓ 	 = Done
	-	 = Not Done
	?	 = Needs Testing
	X	 = Decided not to implement
	/	 = Couldn't do
	*	 = Partially done

	Beta Ready:
	✓	Top-down movement system
	-	Camera positioning system
	-	Weapon spawn systen
	-	Player spawn system (Don't spawn on same tiles)
	-	Death handling
	-	Round restart/end functions
	-	Projectile entity
	
	Weapon idea list:
	*	Bouncing laser (Bounces on players)
	-	Invisible mine
	-	Cloak and Dagger (Invisibility + melee)
	-	Remote missile (Control with mouse)
	-	Shotgun (moving projectiles)
	-	Gatling (many slower moving projectiles)
	*	Melonbomb (blow up whole row + column, reference to Melonbomber)
	-	Rainbow star (invulnerable, kill anyone on contact, Mario reference)
	-	Block remover (removes a block or wall from the grid)
	-	Fragment Bomb (Slow projectile, click again to blow up into many small fragment projectiles)
	-	Wave (Moves along grid, taking random turns for X grid movements)
	-	Napalm (Set a grid on fire for some time)
	-	Smoke grenade (Can't kill but can conceal an area)
	-	Sniper (Small buildup, then instant snipe laser that doesn't bounce, can penetrate)
	-	Airstrike (Missile from above, global range)
	-	Gravity gun (Throw a toilet at someone)
	-	Flamethrower (Damage over time, AoE flame ahead of you)
	-	Turret (WILL target owner too!, low damage faster projectiles)
	-	Safe Zone? (Kills anyone outside a large zone some time after use)
	-	Genji Dash (I NEED HEALING!!!)
	-	Bouncing sawblade?
	-	Flashbang?
	
	Possible
	-	Playermodels and color from sandbox?
	
]]

function ColorToVector( color )
	return Vector(color.r/255, color.g/255, color.b/255)
end

local camangle = Angle(0,90,0)
function GM:SetupMove(ply, mv, cmd)
	mv:SetMoveAngles(camangle)
end