Msg("Cl_init.lua loads!")

include( "shared.lua" )
include( "player.lua" )
include( "weapon_pickups.lua" )

local campos = Vector(0, 125, 1200)
local angle_down = Angle(90,90,0)

net.Receive("dr_campos", function()
	campos = net.ReadVector()
end)

hook.Add("CalcView", "dr_CalcView", function(ply, pos, angles, fov)	
	--if IsValid(ply) then
		local view = {}
		view.origin = campos
		view.angles = angle_down
		view.fov = fov
		view.drawviewer = true
		return view
	--end
end)

local lastangles = Angle()
local chamberedit = false
local editdelay = 0
function GM:CreateMove( cmd )

	if LocalPlayer():Alive() then
		
		if true then
			--cmd:ClearMovement()
			
			local x,y = gui.MousePos()
			local toscreen = LocalPlayer():GetPos():ToScreen()
			local cx,cy = toscreen.x, toscreen.y
			
			local ang = math.deg(math.atan2(cx-x,cy-y))+90
			cmd:SetViewAngles(Angle(0,ang,0))
			
			local but = cmd:GetButtons()
			if input.IsMouseDown(MOUSE_LEFT) then but = but + IN_ATTACK end
			if input.IsMouseDown(MOUSE_RIGHT) then but = but + IN_ATTACK2 end
			if input.IsMouseDown(MOUSE_MIDDLE) then but = but + IN_GRENADE1 end
			
			cmd:SetButtons(but)
			
			if chamberedit and not gui.IsGameUIVisible() then
				if input.WasMousePressed(MOUSE_LEFT) and editdelay < CurTime() then
					local aim = gui.ScreenToVector(gui.MousePos())
					local tr = util.TraceLine({
						start = campos,
						endpos = campos + aim*20000,
						filter = function(ent)
							return ent:GetClass() == "func_door"
						end,
					})
					
					--PrintTable(tr)
					
					-- Always send, even if entity is worldspawn (let server retrace)
					net.Start("data_chamberedit")
						net.WriteEntity(tr.Entity)
						net.WriteVector(tr.HitPos)
					net.SendToServer()
					
					editdelay = CurTime() + 0.1
				end
			end
			
		else
		
		end
	end
end

gui.EnableScreenClicker(true)

net.Receive("data_chamberedit", function()
	chamberedit = net.ReadBool()
end)

