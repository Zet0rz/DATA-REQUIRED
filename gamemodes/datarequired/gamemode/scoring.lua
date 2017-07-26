
if SERVER then
	util.AddNetworkString("data_testcomplete")
	util.AddNetworkString("data_teststart")
	
	GM.RoundNumber = 0
	
	function GM:TestComplete(winner)
		net.Start("data_testcomplete")
			net.WriteUInt(self.RoundNumber, 8)
			if IsValid(winner) then
				winner:AddFrags(1)
				net.WriteBool(true)
				net.WriteEntity(winner)
				if winner:Frags() >= GetConVar("dreq_maxwins"):GetInt() then
					net.WriteBool(true)
					timer.Simple(16, function()
						self:ResetTests()
						self:BeginRound()
					end)
				else
					net.WriteBool(false)
					timer.Simple(10, function()
						self:BeginRound()
					end)
				end
			else
				net.WriteBool(false)
				timer.Simple(10, function()
					self:BeginRound()
				end)
			end
		net.Broadcast()
	end
	
	function GM:TestStart()
		self.RoundNumber = self.RoundNumber + 1
		net.Start("data_teststart")
			net.WriteUInt(self.RoundNumber, 8)
		net.Broadcast()
	end
	
	function GM:ResetTests()
		for k,v in pairs(player.GetAll()) do
			v:SetFrags(0)
		end
		self.RoundNumber = 0
	end
	
else
	-- Variables
	local starttexttime = 3
	local winnerscreentime = 3
	
	local textcolor = Color(200,255,200, 100)
	local namecolor = Color(255,200,200, 100)
	local outlinecolor = Color(0,50,0, 100)
	local outlinewidth = 2
	
	-- Let's create a custom Scoreboard!
	

	-- Used by the code
	local roundnum = 0
	local starttextend = 0
	
	local function ShowStartScreen()
		local removetime = CurTime()+starttexttime
		local str = (roundnum == 1 and "[NEW PROTOCOL] " or "") .. "- Test "..roundnum.." Initialized -"
		local str2 = "Collect most data by surviving until the end"
		
		local ply = LocalPlayer()
		
		local effecttime = removetime - 0.15
		hook.Add("HUDPaint", "data_testcomplete", function()
			local w,h = ScrW(), ScrH()
			draw.SimpleTextOutlined(str, "DATAWeaponName", w/2, h/2-20, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolor)
			draw.SimpleTextOutlined(str2, "DATAWeaponDesc", w/2, h/2+10, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolor)
			
			if ply:Team() == TEAM_TESTSUBJECTS then
				local pos = ply:GetPos():ToScreen()
				draw.SimpleTextOutlined("! YOU !", "DATAWeaponName", pos.x, pos.y-20, namecolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolor)
				draw.SimpleTextOutlined("v", "DATAWeaponDesc", pos.x, pos.y-5, namecolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolor)
			end
			
			if CurTime() > effecttime then			
				local num = math.random(5)
				surface.SetDrawColor(150,255,150,100)
				for i = 1, num do
					local rw = math.random(10,100)
					local rh = math.random(10,30)
					local rx = math.random(w/2-300, w/2+300-rw)
					local ry = math.random(h/2-100, h/2+40-rh)
					surface.DrawRect(rx, ry, rw, rh)
				end
			end
			
			if CurTime() > removetime then
				hook.Remove("HUDPaint", "data_testcomplete")
			end
		end)
	end
	
	local function ShowEndScreen(winner, reset)
		local removetime = CurTime()+winnerscreentime
		if reset then removetime = CurTime()+winnerscreentime*2 end
		local str = "- Test "..roundnum.." Complete -"
		local str2 = IsValid(winner) and (reset and "[PROTOCOL COMPLETE] - "..winner:Nick().." collected most data" or winner:Nick().." collected most data") or "Not enough data collected"
		
		local effecttime = CurTime() + 0.15
		hook.Add("HUDPaint", "data_testcomplete", function()
			local w,h = ScrW(), ScrH()
			draw.SimpleTextOutlined(str, "DATAWeaponName", w/2, h/2-20, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolor)
			draw.SimpleTextOutlined(str2, "DATAWeaponDesc", w/2, h/2+10, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolor)
			
			if CurTime() < effecttime then				
				local num = math.random(5)
				surface.SetDrawColor(150,255,150,100)
				for i = 1, num do
					local rw = math.random(10,100)
					local rh = math.random(10,30)
					local rx = math.random(w/2-300, w/2+300-rw)
					local ry = math.random(h/2-100, h/2+40-rh)
					surface.DrawRect(rx, ry, rw, rh)
				end
			end
			
			if CurTime() > removetime then
				hook.Remove("HUDPaint", "data_testcomplete")
				GAMEMODE:ScoreboardShow()
			end
		end)
	end
	
	net.Receive("data_teststart", function()
		roundnum = net.ReadUInt(8)
		starttextend = CurTime() + starttexttime
		GAMEMODE:ScoreboardHide()
		ShowStartScreen()
	end)
	
	net.Receive("data_testcomplete", function()
		roundnum = net.ReadUInt(8)
		local winner = NULL
		if net.ReadBool() then
			winner = net.ReadEntity()
		end
		ShowEndScreen(winner, net.ReadBool())
	end)

end