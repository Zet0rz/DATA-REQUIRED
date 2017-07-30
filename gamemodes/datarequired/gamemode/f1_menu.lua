if SERVER then
	util.AddNetworkString("data_f1")
	
	function GM:ShowHelp(ply)
		-- Load in weapon data
		local tbl = {}
		for k,v in pairs(self.EnabledWeapons) do
			if v then tbl[k] = true else tbl[k] = false end
		end
		net.Start("data_f1")
			net.WriteTable(tbl)
		net.Send(ply)
	end
	
	util.AddNetworkString("data_mazes")
	net.Receive("data_mazes", function(len, ply)
		if net.ReadBool() then
			local name = net.ReadString()
			local map
			if name and GAMEMODE.Mazes[name] then map = GAMEMODE.Mazes[name] elseif name == "current" then map = GAMEMODE.CurrentMap end
			if map then
				net.Start("data_mazes")
					net.WriteBool(true)
					net.WriteTable(map)
				net.Send(ply)
			end
		else
			net.Start("data_mazes")
				net.WriteBool(false)
				net.WriteTable(GAMEMODE.EnabledMazes)
			net.Send(ply)
		end
	end)
	
	util.AddNetworkString("data_editing")
	net.Receive("data_editing", function(len, ply)
		if ply:IsSuperAdmin() then
			local target = net.ReadEntity()
			if IsValid(target) then
				target:EnableEditor(not target:GetEditing())
				ply:ChatPrint(target:GetEditing() and target:Nick().." is now editing" or target:Nick().." is no longer editing")
			end
		end
	end)
	
	util.AddNetworkString("data_mazesaveload")
	net.Receive("data_mazesaveload", function(len, ply)
		if ply:IsSuperAdmin() then
			if net.ReadBool() then
				local name = net.ReadString()
				if name and name ~= "" then
					GAMEMODE:SaveMazeToFile(name, GAMEMODE.CurrentMap)
					GAMEMODE:LoadMaze(name, GAMEMODE.CurrentMap)
					net.Start("data_mazes")
						net.WriteBool(false)
						net.WriteTable(GAMEMODE.EnabledMazes)
					net.Send(ply)
				end
			else
				local name = net.ReadString()
				if name and GAMEMODE.Mazes[name] then
					GAMEMODE:LoadMap(name)
				end
			end
		end
	end)
	
	util.AddNetworkString("data_enabledisable")
	net.Receive("data_enabledisable", function(len, ply)
		if ply:IsSuperAdmin() then
			if net.ReadBool() then -- Mazes
				local name = net.ReadString()
				if name and GAMEMODE.Mazes[name] then
					GAMEMODE.EnabledMazes[name] = net.ReadBool()
				end
			else -- Weapons
				local class = net.ReadString()
				if class and GAMEMODE.WeaponPickups[class] then
					if net.ReadBool() then GAMEMODE:EnableWeapon(class) else GAMEMODE:DisableWeapon(class) end
				end
			end
		end
	end)
	
else
	local linecolor1 = Color(0,100,0)
	local linecolor2 = Color(0,120,0)

	local textcolor = Color(150,255,150)
	local lockedtext = Color(20,150,20)
	local outlinecolor = Color(0,50,0,200)

	local textcolor2 = Color(200,255,200)
	
	local function drawcorners(w, h, width, length, corner1, corner2, corner3, corner4)
		if corner1 then
			surface.DrawRect(0,0,length,width)
			surface.DrawRect(0,width,width,length-width)
		end
		
		if corner2 then
			surface.DrawRect(w-length,0,length,width)
			surface.DrawRect(w-width,width,width,length-width)
		end
		
		if corner3 then
			surface.DrawRect(0,h-width,length,width)
			surface.DrawRect(0,h-length,width,length-width)
		end
		
		if corner4 then
			surface.DrawRect(w-length,h-width,length,width)
			surface.DrawRect(w-width,h-length,width,length-width)
		end
	end

	-- A custom painted DPropertySheet
	local oncolor = Color(0,100,0,255)
	local offcolor = Color(0,50,0,100)
	local DATA_SHEET = {
		Paint = function( self, w, h )
			surface.SetDrawColor(0,50,0,150)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0,255)
			drawcorners(w,h,4,20, false, true, true, true)
		end,
		AddSheet = function(self, label, panel, material, NoStretchX, NoStretchY, Tooltip)

			if ( !IsValid( panel ) ) then return end

			local Sheet = {}

			Sheet.Name = label

			Sheet.Tab = vgui.Create( "DTab", self )
			Sheet.Tab:SetTooltip( Tooltip )
			Sheet.Tab:Setup( label, self, panel, material )
			Sheet.Tab:SetFont("DATAScoreboard2")
			Sheet.Tab.Paint = function(self, w, h)
				if self:IsActive() then
					draw.RoundedBox(2, 0, 0, w, h, oncolor)
					surface.SetDrawColor(0,255,0)
					drawcorners(w,h,3,10,true,true,false,false)
				else
					draw.RoundedBox(2, 0, 0, w, h, offcolor)
					surface.SetDrawColor(0,150,0)
					drawcorners(w,h,3,10,true,true,true,true)
				end
			end

			Sheet.Panel = panel
			Sheet.Panel.NoStretchX = NoStretchX
			Sheet.Panel.NoStretchY = NoStretchY
			Sheet.Panel:SetPos( self:GetPadding(), 20 + self:GetPadding() )
			Sheet.Panel:SetVisible( false )

			panel:SetParent( self )

			table.insert( self.Items, Sheet )

			if ( !self:GetActiveTab() ) then
				self:SetActiveTab( Sheet.Tab )
				Sheet.Panel:SetVisible( true )
			end

			self.tabScroller:AddPanel( Sheet.Tab )

			return Sheet
		end
	}
	DATA_SHEET = vgui.RegisterTable( DATA_SHEET, "DPropertySheet" )

	-- Button
	local DATA_BUTTON = {
		Paint = function( self, w, h )
			surface.SetDrawColor(0,50,0,150)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0,255)
			drawcorners(w,h,3,10, true, true, true, true)
		end,
		Init = function(self)
			self:SetFont("DATAScoreboard2")
			self:SetTextColor(textcolor)
		end,
	}
	DATA_BUTTON = vgui.RegisterTable( DATA_BUTTON, "DButton" )
	
	-- Panel Frame
	local DATA_PANEL = {
		Paint = function( self, w, h )
			surface.SetDrawColor(0,50,0,150)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0,255)
			drawcorners(w,h,3,10, true, true, true, true)
		end
	}
	DATA_PANEL = vgui.RegisterTable( DATA_PANEL, "DPanel" )

	-- Checkbox
	local DATA_CHECKBOX = {
		Paint = function(self, w, h)
			local str = self:GetChecked() and "[X]" or "[  ]"
			draw.SimpleTextOutlined(str, "DATAScoreboard2", w/2, h/2, self:IsEnabled() and textcolor or lockedtext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, outlinecolor)
		end,
	}
	DATA_CHECKBOX = vgui.RegisterTable( DATA_CHECKBOX, "DCheckBox" )
	
	-- Button
	local DATA_SCROLL = {
		Init = function(self)
			local bar = self:GetVBar()
			bar:SetVisible(true)
			bar.Paint = function(self,w,h)
				surface.SetDrawColor(0,50,0,150)
				surface.DrawRect(0,0,w,h)
				surface.SetDrawColor(0,255,0,255)
				drawcorners(w,h,2,5,true,true,true,true)
			end
			bar.btnUp.Paint = function(self,w,h)
				surface.SetDrawColor(0,50,0,255)
				surface.DrawRect(0,0,w,h)
				surface.SetDrawColor(0,255,0,255)
				drawcorners(w,h,2,5,true,true,true,true)
				draw.SimpleTextOutlined("^", "DATAScoreboard3", w/2, h/2, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, outlinecolor)
			end
			bar.btnDown.Paint = function(self,w,h)
				surface.SetDrawColor(0,50,0,255)
				surface.DrawRect(0,0,w,h)
				surface.SetDrawColor(0,255,0,255)
				drawcorners(w,h,2,5,true,true,true,true)
				draw.SimpleTextOutlined("v", "DATAScoreboard3", w/2, h/2, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, outlinecolor)
			end
			bar.btnGrip.Paint = function(self,w,h)
				surface.SetDrawColor(0,50,0,255)
				surface.DrawRect(0,0,w,h)
				surface.SetDrawColor(0,255,0,255)
				
				surface.DrawRect(0,0,w,2)
				surface.DrawRect(0,2,2,h-2)
				surface.DrawRect(w-2,2,2,h-2)
				surface.DrawRect(2,h-2,w-4,2)
			end
		end,
		Rebuild = function(self)
			self:GetCanvas():SizeToChildren(false, true )
			-- Although this behaviour isn't exactly implied, center vertically too
			if (self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall()) then
				self:GetCanvas():SetPos(0, (self:GetTall() - self:GetCanvas():GetTall()) * 0.5)
			end
		end,
	}
	DATA_SCROLL = vgui.RegisterTable( DATA_SCROLL, "DScrollPanel" )
	
	local mazesheet
	local mazepreview
	local mazename
	local framecolor = Color(0,0,0,200)
	net.Receive("data_mazes", function()
		if net.ReadBool() then
			local tbl = net.ReadTable()
			mazepreview = tbl
		else
			local tbl = net.ReadTable()
			local sorted = table.GetKeys(tbl)
			table.sort(sorted, function(a,b) return a<b end)
			local admin = LocalPlayer():IsSuperAdmin()
			
			if IsValid(mazesheet) then
				for k,v in pairs(mazesheet:GetChildren()) do
					v:Remove()
				end
				local x,y = mazesheet:GetSize()
				for _,k in pairs(sorted) do
					local v = tbl[k] -- We're going alphabetically here
					local p = vgui.Create("DPanel")
					p:SetSize(278,40)
					p.Paint = function(self,w,h)
						draw.RoundedBox(2,0,0,w,h,framecolor)
						surface.SetDrawColor(0,255,0)
						drawcorners(w,h,3,10,true,true,true,true)
					end
					local txt = vgui.Create("DLabel", p)
					txt:SetFont("DATAScoreboard2")
					txt:SetText(k)
					txt:SetPos(10,10)
					txt:SizeToContents()
					
					local but = vgui.Create("DButton", p)
					but.Paint = function() end
					but:SetText("")
					but:SetSize(280,40)
					but.DoClick = function(self)
						net.Start("data_mazes")
							net.WriteBool(true)
							net.WriteString(k)
						net.SendToServer()
						if IsValid(mazename) then mazename:SetText(k) end
					end
					
					local chk = vgui.CreateFromTable(DATA_CHECKBOX, p)
					chk:SetPos(240,4)
					chk:SetSize(30,30)
					chk:SetChecked(v)
					chk:SetEnabled(admin)
					chk.OnChange = function(self, bool)
						net.Start("data_enabledisable")
							net.WriteBool(true) -- mazes
							net.WriteString(k)
							net.WriteBool(bool)
						net.SendToServer()
					end
					
					mazesheet:Add(p)
				end
				-- Doesn't work? :/
				mazesheet:GetParent():PerformLayout()
			end
		end
	end)

	local weaponmat = Material("SGM/playercircle")
	local rotspeed = Angle(0,10,0)
	local function OpenF1Menu()
		local weapondata = net.ReadTable()
		local admin = LocalPlayer():IsSuperAdmin()
	
		net.Start("data_mazes")
			net.WriteBool(true)
			net.WriteString("current")
		net.SendToServer()
	
		local frame = vgui.Create("DFrame")
		frame:SetTitle("VR Environment Control Panel")
		frame:SetSize(600,400)
		frame:Center()
		frame:SetDeleteOnClose(true)
		frame:SetSizable(false)
		frame.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, framecolor)
			surface.SetDrawColor(0,255,0)
			drawcorners(w,h,2,40,true,true,true,true)
		end
		frame:MakePopup()
		
		local sheet = vgui.CreateFromTable(DATA_SHEET, frame)
		sheet:Dock(FILL)
		
		local weaponpanel = vgui.Create( "DPanel", sheet )
		weaponpanel.Paint = function( self, w, h ) draw.RoundedBox(2, 0, 0, w, h, oncolor) end
		local weaponinfo = vgui.Create("DPanel", weaponpanel)
		weaponinfo.Paint = function(self,w,h)
			draw.RoundedBox(2, 0, 0, w, h, offcolor)
		end
		weaponinfo:SetSize(280,350)
		weaponinfo:Dock(RIGHT)
		local weaponmodel = vgui.Create("DPanel", weaponinfo)
		local modelpanel = vgui.Create("DModelPanel", weaponmodel)
		modelpanel:Dock(FILL)
		modelpanel:SetCamPos(Vector(0,0,100))
		modelpanel:SetLookAng(Angle(90,0,0))
		
		function modelpanel:LayoutEntity(Entity)
			Entity:SetAngles(Entity:GetAngles()+(rotspeed*FrameTime()))
			if Entity.OffsetPos then
				Entity.OffsetPos:Rotate(rotspeed*FrameTime())
				Entity:SetPos(Entity.OffsetPos)
			end
		end
		
		weaponmodel.Paint = function(self,w,h)
			surface.SetDrawColor(0,20,0)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0)
			drawcorners(w,h,4,30,true,true,true,true)
			if self.Weapon and GAMEMODE.WeaponPickups[self.Weapon] then
				local data = GAMEMODE:GetWeaponPickup(self.Weapon)
				surface.SetMaterial(weaponmat)
				local col = data.color
				surface.SetDrawColor(col.r,col.g,col.b)
				local radius = 65
				surface.DrawTexturedRect(w/2-radius,h/2-radius,radius*2,radius*2)
			end
		end
		weaponmodel:SetSize(270,165)
		weaponmodel:SetPos(5,5)
		function weaponmodel:LoadWeapon(class)
			if class and GAMEMODE.WeaponPickups[class] then
				self.Weapon = class
				local data = GAMEMODE:GetWeaponPickup(self.Weapon)
				modelpanel:SetModel(data.model)
				local ent = modelpanel:GetEntity()
				ent:SetPos(Vector(0,0,0))
				if data.offset then ent.OffsetPos = Vector(data.offset.x, data.offset.y, data.offset.z) else ent.OffsetPos = nil end
				if data.angle then ent:SetAngles(data.angle) else ent:SetAngles(Angle(0,0,0)) end
				if data.scale then ent:SetModelScale(data.scale) else ent:SetModelScale(1) end
			end
		end
		
		local weaponnameholder = vgui.CreateFromTable(DATA_PANEL, weaponinfo)
		weaponnameholder:SetSize(270, 35)
		weaponnameholder:SetPos(5, 175)
		weaponnameholder:DockPadding(5,5,5,5)
		weaponnameholder.Paint = function( self, w, h )
			surface.SetDrawColor(0,20,0,255)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0,255)
			drawcorners(w,h,3,10, true, true, true, true)
		end
		local weaponname = vgui.Create("DLabel", weaponnameholder)
		weaponname:SetFont("DATAScoreboard2")
		weaponname:SetText("No Weapon Selected")
		weaponname:Dock(FILL)
		
		local weapondescholder = vgui.CreateFromTable(DATA_PANEL, weaponinfo)
		weapondescholder:SetSize(270, 60)
		weapondescholder:SetPos(5, 215)
		weapondescholder:DockPadding(5,5,5,5)
		weapondescholder.Paint = function( self, w, h )
			surface.SetDrawColor(0,50,0,255)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0,255)
			drawcorners(w,h,3,10, true, true, true, true)
		end
		local weapondesc = vgui.Create("DLabel", weapondescholder)
		weapondesc:SetFont("DATAScoreboard2.5")
		weapondesc:SetText("Select a weapon from the list to view data.")
		weapondesc:SetWrap(true)
		weapondesc:SetContentAlignment(7)
		weapondesc:Dock(FILL)
		
		local weaponinstrholder = vgui.CreateFromTable(DATA_PANEL, weaponinfo)
		weaponinstrholder:SetSize(270, 45)
		weaponinstrholder:SetPos(5, 280)
		weaponinstrholder:DockPadding(5,5,5,5)
		weaponinstrholder.Paint = function( self, w, h )
			surface.SetDrawColor(0,50,0,255)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0,255)
			drawcorners(w,h,3,10, true, true, true, true)
		end
		local weaponinstr = vgui.Create("DLabel", weaponinstrholder)
		weaponinstr:SetFont("DATAScoreboard3")
		weaponinstr:SetText("These fields will contain information about the selected weapon prototype.")
		weaponinstr:SetWrap(true)
		weaponinstr:SetContentAlignment(7)
		weaponinstr:Dock(FILL)
		
		local weaponlist = vgui.CreateFromTable(DATA_SCROLL, weaponpanel)
		weaponlist:Dock(FILL)
		local weaponlayout = vgui.Create("DIconLayout", weaponlist)
		weaponlayout:Dock(FILL)
		weaponlayout:SetSpaceX(5)
		weaponlayout:SetSpaceY(5)
		
		local sorted = table.GetKeys(weapondata)
		table.sort(sorted, function(a,b) return a<b end)		
		for _,k in pairs(sorted) do
			local v = weapondata[k]
			local wep = weapons.Get(k)
			if wep then
				local p = vgui.Create("DPanel")
				p:SetSize(278,40)
				p.Paint = function(self,w,h)
					draw.RoundedBox(2,0,0,w,h,framecolor)
					surface.SetDrawColor(0,255,0)
					drawcorners(w,h,3,10,true,true,true,true)
				end
				local txt = vgui.Create("DLabel", p)
				txt:SetFont("DATAScoreboard2")
				txt:SetText(wep.PrintName)
				txt:SetPos(10,10)
				txt:SizeToContents()
				
				local but = vgui.Create("DButton", p)
				but.Paint = function() end
				but:SetText("")
				but:SetSize(280,40)
				but.DoClick = function(self)
					weaponname:SetText(wep.PrintName)
					weapondesc:SetText(wep.Purpose)
					weaponinstr:SetText(wep.Instructions)
					weaponmodel:LoadWeapon(k)
				end
				
				local chk = vgui.CreateFromTable(DATA_CHECKBOX, p)
				--local chk = vgui.Create("DCheckBox",p)
				chk:SetPos(240,4)
				chk:SetSize(30,30)
				chk:SetChecked(v)
				chk:SetEnabled(admin)
				chk.OnChange = function(self, bool)
					net.Start("data_enabledisable")
						net.WriteBool(false) -- weapons
						net.WriteString(k)
						net.WriteBool(bool)
					net.SendToServer()
				end
				
				weaponlayout:Add(p)
			end
		end
		sheet:AddSheet( "Prototype Weaponry", weaponpanel )
		
		local panel2 = vgui.Create( "DPanel", sheet )
		panel2.Paint = function( self, w, h ) draw.RoundedBox(2, 0, 0, w, h, oncolor) end
		local mazeview = vgui.Create("DPanel", panel2)
		mazeview.Paint = function(self,w,h)
			draw.RoundedBox(2, 0, 0, w, h, offcolor)
		end
		mazeview:SetSize(280,350)
		mazeview:Dock(RIGHT)
		local mazemap = vgui.Create("DPanel", mazeview)
		mazemap.Paint = function(self,w,h)
			if mazepreview then
				surface.SetDrawColor(0,255,0)
				local ratio = 8
				local long = math.ceil(w/(16*ratio+15)*ratio)
				local short = math.ceil(long/ratio)
				local full = long+short
				local edge = 5
				surface.DrawRect(0,0,w,edge)
				surface.DrawRect(0,edge,edge,h-edge)
				surface.DrawRect(w-edge,edge,edge,h-edge)
				surface.DrawRect(edge,h-edge,w-edge*2,edge)
				for i = 0, 14 do
					for j = 0, 8 do
						if (mazepreview.wallx[i] and mazepreview.wallx[i][j]) or (mazepreview.block[i] and mazepreview.block[i][j] and mazepreview.block[i][j-1]) then
							surface.DrawRect(i*full+short,j*full,long,short)
						end
						if (mazepreview.wally[i] and mazepreview.wally[i][j]) or (mazepreview.block[i] and mazepreview.block[i][j] and mazepreview.block[i-1] and mazepreview.block[i-1][j]) then
							surface.DrawRect(i*full,j*full+short,short,long)
						end
						if mazepreview.block[i] and mazepreview.block[i][j] then
							surface.DrawRect(i*full+short,j*full+short,long,long)
						end
						if (mazepreview.corner[i] and mazepreview.corner[i][j]) or (mazepreview.wally[i] and mazepreview.wally[i][j] and mazepreview.wally[i][j-1]) or (mazepreview.wallx[i] and mazepreview.wallx[i][j] and mazepreview.wallx[i-1] and mazepreview.wallx[i-1][j])
						or (mazepreview.block[i] and mazepreview.block[i][j] and mazepreview.block[i][j-1] and mazepreview.block[i-1] and mazepreview.block[i-1][j] and mazepreview.block[i-1][j-1])
						then
							surface.DrawRect(i*full,j*full,short,short)
						end
					end
				end
			end
		end
		mazemap:SetSize(270,165)
		mazemap:SetPos(5,5)
		
		mazename = vgui.Create("DTextEntry", mazeview)
		mazename:SetSize(270, 35)
		mazename:SetPos(5, 175)
		mazename:SetFont("DATAScoreboard2")
		mazename:SetText("[CURRENT MAZE]")
		mazename:SetEditable(admin)
		mazename.Paint = function(self,w,h)
			surface.SetDrawColor(0,50,0,255)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0)
			drawcorners(w,h,3,10,true,true,true,true)
			self:DrawTextEntryText(textcolor, oncolor, offcolor)
		end
		
		local update = vgui.CreateFromTable(DATA_BUTTON, mazeview)
		update:SetSize(130,35)
		update:SetText("Update Preview")
		update:SetPos(145, 215)
		update:SetTooltip("Updates the preview to the current maze")
		update:SetEnabled(admin)
		update.DoClick = function(self)
			net.Start("data_mazes")
				net.WriteBool(true)
				net.WriteString("current")
			net.SendToServer()
			if IsValid(mazename) then
				mazename:SetText("[CURRENT MAZE]")
			end
		end
		
		local load = vgui.CreateFromTable(DATA_BUTTON, mazeview)
		load:SetSize(135,35)
		load:SetText("Build Selected")
		load:SetPos(5, 215)
		load:SetTooltip("Builds the currently selected maze into the arena")
		load:SetEnabled(admin)
		load.DoClick = function(self)
			net.Start("data_mazesaveload")
				net.WriteBool(false)
				net.WriteString(mazename:GetText())
			net.SendToServer()
		end
		
		local dropdown = vgui.Create("DComboBox", mazeview)
		dropdown:SetSize(135, 30)
		dropdown:SetPos(5,255)
		dropdown:SetFont("DATAScoreboard2")
		dropdown:SetTextColor(textcolor)
		dropdown:AddChoice(LocalPlayer():Nick(), LocalPlayer(), true)
		for k,v in pairs(player.GetAll()) do
			if v ~= LocalPlayer() then
				dropdown:AddChoice(v:Nick(), v, false)
			end
		end
		dropdown.Paint = function(self,w,h)
			surface.SetDrawColor(0,50,0,150)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0)
			drawcorners(w,h,3,10,true,true,true,true)
		end
		
		local edit = vgui.CreateFromTable(DATA_BUTTON, mazeview)
		edit:SetSize(130,30)
		edit:SetText("Toggle Editing")
		edit:SetPos(145, 255)
		edit:SetTooltip("Toggles maze editing on the selected player")
		edit:SetEnabled(admin)
		edit.DoClick = function(self)
			local name, ply = dropdown:GetSelected()
			net.Start("data_editing")
				net.WriteEntity(ply)
			net.SendToServer()
		end
		
		local save = vgui.CreateFromTable(DATA_BUTTON, mazeview)
		save:SetSize(270,35)
		save:SetText("Save to File")
		save:SetPos(5, 290)
		save:SetTooltip("Saves the maze to .txt file and loads it into the game")
		save:SetEnabled(admin)
		save.DoClick = function(self)
			net.Start("data_mazesaveload")
				net.WriteBool(true)
				net.WriteString(mazename:GetText())
			net.SendToServer()
		end
		save.Paint = function(self,w,h)
			surface.SetDrawColor(0,50,0,255)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,255,0,255)
			drawcorners(w,h,3,10, true, true, true, true)
		end
		
		if not admin then
			local adminblock = vgui.Create("DPanel", mazeview)
			adminblock:SetPos(5, 175)
			adminblock:SetSize(270,150)
			adminblock.Paint = function(self,w,h)
				surface.SetDrawColor(0,0,0,250)
				surface.DrawRect(0,0,w,h)
				surface.SetDrawColor(0,255,0)
				drawcorners(w,h,4,30,true,true,true,true)
				draw.SimpleTextOutlined("[ADMIN REQUIRED]", "DATAScoreboard1", w/2, h/2, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, outlinecolor)
			end
		end
		
		local scroll = vgui.CreateFromTable(DATA_SCROLL, panel2)
		scroll:Dock(FILL)
		mazesheet = vgui.Create("DIconLayout", scroll)
		mazesheet:Dock(FILL)
		mazesheet:SetSpaceY(5)
		net.Start("data_mazes")
			net.WriteBool(false)
		net.SendToServer()
		
		sheet:AddSheet("Maze Environment", panel2)
	end
	net.Receive("data_f1", OpenF1Menu)
end
