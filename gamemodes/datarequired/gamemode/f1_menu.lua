if SERVER then
	util.AddNetworkString("data_f1")
	
	function GM:ShowHelp(ply)
		if ply:IsSuperAdmin() then
			net.Start("data_f1")
			net.Send(ply)
		end
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
	
else
	local linecolor1 = Color(0,100,0)
	local linecolor2 = Color(0,120,0)

	local textcolor = Color(150,255,150)
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
			
		end,
	}
	DATA_BUTTON = vgui.RegisterTable( DATA_BUTTON, "DButton" )

	-- Checkbox
	local DATA_CHECKBOX = {
		Paint = function( self, w, h )
			local str = self:GetChecked() and "[X]" or "[  ]"
			draw.SimpleTextOutlined(str, "DATAScoreboard2", w/2, h/2, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, outlinecolor)
		end,
	}
	DATA_CHECKBOX = vgui.RegisterTable( DATA_CHECKBOX, "DCheckBox" )
	
	local mazesheet
	local mazepreview
	local framecolor = Color(0,0,0,200)
	net.Receive("data_mazes", function()
		if net.ReadBool() then
			local tbl = net.ReadTable()
			mazepreview = tbl
		else
			local tbl = net.ReadTable()
			if IsValid(mazesheet) then
				for k,v in pairs(mazesheet:GetChildren()) do
					v:Remove()
				end
				for k,v in pairs(tbl) do
					local p = vgui.Create("DPanel")
					p:SetSize(280,40)
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
					end
					
					local chk = vgui.CreateFromTable(DATA_CHECKBOX, p)
					chk:SetPos(240,4)
					chk:SetSize(30,30)
					chk:SetChecked(v)
					
					mazesheet:Add(p)
				end
			end
		end
	end)

	local function OpenF1Menu()
		net.Start("data_mazes")
			net.WriteBool(true)
			net.WriteString("current")
		net.SendToServer()
	
		local frame = vgui.Create("DFrame")
		frame:SetTitle("F1 Menu - CHANGE ME")
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
		
		local weaponry = vgui.Create( "DScrollPanel", sheet )
		weaponry.Paint = function( self, w, h )
			draw.RoundedBox(2, 0, 0, w, h, oncolor)
		end
		local pnl = vgui.Create("DIconLayout", weaponry)
		pnl:Dock(FILL)
		pnl:SetSpaceX(5)
		pnl:SetSpaceY(5)
		for k,v in pairs(GAMEMODE.WeaponPickups) do
			local wep = weapons.Get(k)
			if wep then
				local p = vgui.Create("DPanel")
				p:SetSize(280,40)
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
				
				local chk = vgui.CreateFromTable(DATA_CHECKBOX, p)
				--local chk = vgui.Create("DCheckBox",p)
				chk:SetPos(240,4)
				chk:SetSize(30,30)
				chk:SetChecked(true)
				
				pnl:Add(p)
			end
		end
		sheet:AddSheet( "Weaponry", weaponry )
		
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
		
		local scroll = vgui.Create("DScrollPanel", panel2)
		scroll:Dock(LEFT)
		mazesheet = vgui.Create("DIconLayout", scroll)
		mazesheet:Dock(FILL)
		net.Start("data_mazes")
			net.WriteBool(false)
		net.SendToServer()
		
		sheet:AddSheet( "Maze Environment", panel2 )
	end
	net.Receive("data_f1", OpenF1Menu)
end
