Msg("Cl_init.lua loads!")

include( "shared.lua" )
include( "player.lua" )
include( "weapon_pickups.lua" )
include("cl_hud.lua")
include( "scoring.lua" )
include( "cl_scoreboard.lua" )
include( "f1_menu.lua" )

local campos = Vector(0, 125, 1200)
local angle_down = Angle(90,90,0)
local playfov = 30
local playcam = Vector(0,125,3200)

net.Receive("dr_campos", function()
	campos = net.ReadVector()
end)
local chamberedit = false

hook.Add("CalcView", "dr_CalcView", function(ply, pos, angles, fov)	
	--if IsValid(ply) then
		local view = {}
		view.origin = (chamberedit and campos or playcam)
		if ply:Alive() then view.origin = view.origin + (pos-ply:GetShootPos()) end
		view.angles = angle_down
		view.fov = chamberedit and fov or playfov
		view.drawviewer = true
		return view
	--end
end)

local lastangles = Angle()
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
			
			if not gui.IsGameUIVisible() then
				if input.WasMousePressed(MOUSE_LEFT) and editdelay < CurTime() then
					local aim = chamberedit and gui.ScreenToVector(x,y) or util.AimVector(angle_down, playfov*3, x,y, ScrW(),ScrH())
					
					local wep = LocalPlayer():GetActiveWeapon()
					if IsValid(wep) and wep.OnScreenClick then
						wep:OnScreenClick(aim)
					end
				
					if chamberedit then
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
					end
					
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

hook.Add("PrePlayerDraw", "data_playerweapondraws", function(ply)
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep.PrePlayerDraw and not ply.WEAPONDRAW then
		ply.WEAPONDRAW = true
		local val = wep:PrePlayerDraw(ply)
		ply.WEAPONDRAW = nil
		return val
	end
end)

-- Replacing arena white light textures
local mat = Material("lights/white001")
local fadespeed = 1
--[[hook.Add("RenderScreenspaceEffects", "data_arenalights", function()
	render.ClearStencil()
	render.SetStencilEnable(true)
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		render.SetStencilReferenceValue(15)
		render.SetStencilFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		render.SetBlend(0)
			
		render.SetBlend(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		surface.SetDrawColor(0,255,0)
		surface.DrawRect(-ScrW(),-ScrH(),ScrW()*2,ScrH()*2)
	render.SetStencilEnable(false)
end)]]

function GetCamPos()
	return campos, angle_down
end
