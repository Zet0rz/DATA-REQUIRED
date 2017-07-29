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
local toscreen = {x=0,y=0}
function GM:CreateMove( cmd )

	if LocalPlayer():Alive() then
		
		if true then
			--cmd:ClearMovement()
			
			local x,y = gui.MousePos()
			--local toscreen2 = LocalPlayer():GetPos():ToScreen()
			--if toscreen2.visible then toscreen = toscreen2 end
			local cx,cy = toscreen.x, toscreen.y
			
			local ang = math.deg(math.atan2(cx-x,cy-y))+90
			cmd:SetViewAngles(Angle(0,ang,0))
			
			local but = cmd:GetButtons()
			if input.IsMouseDown(MOUSE_LEFT) then but = but + IN_ATTACK end
			if input.IsMouseDown(MOUSE_RIGHT) then but = but + IN_ATTACK2 end
			if input.IsMouseDown(MOUSE_MIDDLE) then but = but + IN_GRENADE1 end
			
			cmd:SetButtons(but)
			
			if not gui.IsGameUIVisible() and vgui.IsHoveringWorld() then
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
	if ply == LocalPlayer() then
		toscreen = LocalPlayer():GetPos():ToScreen()
	end
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep.PrePlayerDraw and not ply.WEAPONDRAW then
		ply.WEAPONDRAW = true
		local val = wep:PrePlayerDraw(ply)
		ply.WEAPONDRAW = nil
		ply.INVISIBLE = val
		return val
	end
end)

local playerradius = 30^2
local textcolor = Color(200,255,200, 100)
local outlinecolor = Color(0,50,0, 100)
hook.Add("HUDPaint", "data_playernames", function()
	local x,y = gui.MousePos()
	for k,v in pairs(team.GetPlayers(TEAM_TESTSUBJECTS)) do
		if v:Alive() then
			local toscreen = v:GetPos():ToScreen()
			if (toscreen.x-x)^2+(toscreen.y-y)^2 <= playerradius then
				if not v.DRAWNAME then
					-- Distort fadein effect
					ShowScreenDistortions(1, 0.05, toscreen.x-100, toscreen.y-45, 200, 50,0.5)
					v.DRAWNAME = true
				end
				draw.SimpleTextOutlined(v:Nick(), "DATAWeaponDesc", toscreen.x, toscreen.y-15, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, outlinecolor)
			elseif v.DRAWNAME then
				-- Distort fadeout effect
				ShowScreenDistortions(1, 0.05, toscreen.x-100, toscreen.y-45, 200, 50,0.5)
				v.DRAWNAME = false
			end
		end
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
