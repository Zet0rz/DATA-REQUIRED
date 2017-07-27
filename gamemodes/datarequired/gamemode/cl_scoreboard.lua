
surface.CreateFont("DATAScoreboard1", {
	font = "Arial",
	extended = false,
	size = 28,
	weight = 500,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("DATAScoreboard2", {
	font = "Arial",
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("DATAScoreboard3", {
	font = "Arial",
	extended = false,
	size = 14,
	weight = 500,
	blursize = 0,
	scanlines = 2,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

local linecolor1 = Color(0,100,0)
local linecolor2 = Color(0,120,0)

local textcolor = Color(150,255,150)
local outlinecolor = Color(0,50,0,200)

local textcolor2 = Color(200,255,200)

--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PLAYER_LINE = {
	Init = function( self )

		self.AvatarButton = self:Add( "DButton" )
		self.AvatarButton:Dock( LEFT )
		self.AvatarButton:SetSize( 32, 32 )
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar = vgui.Create( "AvatarImage", self.AvatarButton )
		self.Avatar:SetSize( 32, 32 )
		self.Avatar:SetMouseInputEnabled( false )

		self.Name = self:Add( "DLabel" )
		self.Name:Dock( FILL )
		self.Name:SetContentAlignment(7)
		self.Name:SetFont( "ScoreboardDefault" )
		self.Name:SetTextColor( textcolor2 )
		self.Name:DockMargin( 8, -1, 0, 0 )

		self.Mute = self:Add( "DImageButton" )
		self.Mute:SetSize( 32, 32 )
		self.Mute:Dock( RIGHT )

		self.Ping = self:Add( "DLabel" )
		self.Ping:Dock( RIGHT )
		self.Ping:SetWidth( 50 )
		self.Ping:SetFont( "ScoreboardDefault" )
		self.Ping:SetTextColor( textcolor2 )
		self.Ping:SetContentAlignment( 5 )

		self.Deaths = self:Add( "DLabel" )
		self.Deaths:Dock( RIGHT )
		self.Deaths:SetWidth( 50 )
		self.Deaths:SetFont( "ScoreboardDefault" )
		self.Deaths:SetTextColor( textcolor2 )
		self.Deaths:SetContentAlignment( 5 )

		self.Progress = self:Add( "DPanel" )
		self.Progress:Dock( RIGHT )
		self.Progress:SetWidth( 300 )
		self.Progress:SetContentAlignment( 5 )
		self.Progress.Paint = function(self2, w, h)
			if IsValid(self.Player) then
				surface.SetDrawColor(0,50,0,200)
				surface.DrawRect(0,5,w,h-10)
				local max = GetConVar("dreq_maxwins"):GetInt()
				local num = self.Player:Frags()
				surface.SetDrawColor(0,200,0,200)
				surface.DrawRect(2,7,(w-4)*(num/max),h-14)
				
				draw.SimpleTextOutlined(num.."/"..max, "DATAScoreboard2", w/2, h/2, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, outlinecolor)
			end
		end
		
		self.AliveStatus = self:Add("DLabel")
		self.AliveStatus:SetSize(100,20)
		self.AliveStatus:SetPos(40,20)
		self.AliveStatus:SetFont( "DATAScoreboard3" )
		self.AliveStatus:SetText("ALIVE: [X]")
		
		self.TeamStatus = self:Add("DLabel")
		self.TeamStatus:SetSize(150,20)
		self.TeamStatus:SetPos(120,20)
		self.TeamStatus:SetFont( "DATAScoreboard3" )
		self.TeamStatus:SetText("[YOU]")

		self:Dock( TOP )
		self:DockPadding( 3, 3, 3, 3 )
		self:SetHeight( 32 + 3 * 2 )
		self:DockMargin( 2, 0, 2, 1 )

	end,

	Setup = function( self, pl )

		self.Player = pl
		if pl == LocalPlayer() then
			self:DockMargin(2, 0, 2, 5)
		end

		self.Avatar:SetPlayer( pl )

		self:Think( self )

		--local friend = self.Player:GetFriendStatus()
		--MsgN( pl, " Friend: ", friend )

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) ) then
			self:SetZPos( 9999 ) -- Causes a rebuild
			self:GetParent():GetParent().NumPlayers = #player.GetAll()
			self:Remove()
			return
		end

		if ( self.PName == nil || self.PName != self.Player:Nick() ) then
			self.PName = self.Player:Nick()
			self.Name:SetText( self.PName )
		end
		
		if ( self.NumWins == nil || self.NumWins != self.Player:Frags() ) then
			self.NumWins = self.Player:Frags()
		end

		if ( self.NumDeaths == nil || self.NumDeaths != self.Player:Deaths() ) then
			self.NumDeaths = self.Player:Deaths()
			self.Deaths:SetText( self.NumDeaths )
		end

		if ( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
			self.NumPing = self.Player:Ping()
			self.Ping:SetText( self.NumPing )
		end

		--
		-- Change the icon of the mute button based on state
		--
		if ( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

			self.Muted = self.Player:IsMuted()
			if ( self.Muted ) then
				self.Mute:SetImage( "icon32/muted.png" )
			else
				self.Mute:SetImage( "icon32/unmuted.png" )
			end

			self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

		end
		
		if ( self.Alive == nil || self.Alive != self.Player:Alive() ) then
			self.Alive = self.Player:Alive()
			self.AliveStatus:SetText( "ALIVE: ["..(self.Alive and "X" or " ").."]")
		end

		--
		-- Connecting players go at the very bottom
		--
		if ( self.Player:Team() == TEAM_CONNECTING ) then
			self:SetZPos( 2000 + self.Player:EntIndex() )
			--return
		end

		--
		-- This is what sorts the list. The panels are docked in the z order,
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		if self.Player == LocalPlayer() then
			self:SetZPos(-32000)
		else
			if ( self.Team == nil || self.Team != self.Player:Team() ) then
				self.Team = self.Player:Team()
				self.TeamStatus:SetText( "["..((self.Team == TEAM_TESTSUBJECTS or self.Team == TEAM_DEAD) and "TEAM_TESTSUBJECTS" or "TEAM_LOADING").."]")
			end
			self:SetZPos((self.NumWins * -50) + self.NumDeaths + self.Player:EntIndex())
		end

	end,

	Paint = function( self, w, h )
		if ( !IsValid( self.Player ) ) then
			return
		end

		draw.RoundedBox( 2, 0, 0, w, h, self:GetZPos()%2==0 and linecolor1 or linecolor2 )
	end
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" )

--
-- Here we define a new panel table for the scoreboard. It basically consists
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD = {
	Init = function( self )

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 80 )

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "DATAScoreboard1" )
		self.Name:SetTextColor( Color( 150, 255, 150, 255 ) )
		self.Name:SetPos(10,10)
		self.Name:SetSize(680,100)
		self.Name:SetHeight(40)
		--self.Name:SetContentAlignment( 5 )
		
		local mode = self.Header:Add("DLabel")
		mode:SetFont("DATAScoreboard2")
		mode:SetTextColor(Color(125,200,125))
		mode:SetPos(10,50)
		mode:SetSize(680,20)
		mode:SetHeight(20)
		mode:SetText("[DATA REQUIRED]")
		
		local progress = self.Header:Add("DLabel")
		progress:SetFont("DATAScoreboard2")
		progress:SetTextColor(Color(125,200,125))
		progress:SetPos(360,50)
		progress:SetSize(680,20)
		progress:SetHeight(20)
		progress:SetText("[ PROGRESS ]")
		
		local deaths = self.Header:Add("DLabel")
		deaths:SetFont("DATAScoreboard2")
		deaths:SetTextColor(Color(125,200,125))
		deaths:SetPos(530,50)
		deaths:SetSize(680,20)
		deaths:SetHeight(20)
		deaths:SetText("[ DEATHS ]")
		
		local ping = self.Header:Add("DLabel")
		ping:SetFont("DATAScoreboard2")
		ping:SetTextColor(Color(125,200,125))
		ping:SetPos(620,50)
		ping:SetSize(680,20)
		ping:SetHeight(20)
		ping:SetText("[ LAG ]")

		--self.NumPlayers = self.Header:Add( "DLabel" )
		--self.NumPlayers:SetFont( "ScoreboardDefault" )
		--self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
		--self.NumPlayers:SetPos( 0, 100 - 30 )
		--self.NumPlayers:SetSize( 300, 30 )
		--self.NumPlayers:SetContentAlignment( 4 )

		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock( FILL )
		
		self.NumPlayers = 0

	end,

	PerformLayout = function( self )
		local height = math.min(85 + self.NumPlayers*39, 700)
		self:SetSize( 700, height )
		self:SetPos( ScrW() / 2 - 350, ScrH()/2-height/2-50 )
	end,

	Paint = function( self, w, h )
		draw.RoundedBox( 1, 0, 0, w, h, Color( 0, 20, 0, 220 ) )
		surface.SetDrawColor(0,200,0)
		
		surface.DrawRect(0,0,30,4)
		surface.DrawRect(0,4,4,26)
		
		surface.DrawRect(w-30,0,30,4)
		surface.DrawRect(w-4,4,4,26)
		
		surface.DrawRect(0,h-4,30,4)
		surface.DrawRect(0,h-30,4,26)
		
		surface.DrawRect(w-30,h-4,30,4)
		surface.DrawRect(w-4,h-30,4,26)
	end,

	Think = function( self, w, h )

		self.Name:SetText( GetHostName() )

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		for id, pl in pairs( plyrs ) do

			if ( IsValid( pl.ScoreEntry ) ) then continue end

			pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
			pl.ScoreEntry:Setup( pl )

			self.Scores:AddItem( pl.ScoreEntry )
			self.NumPlayers = self.NumPlayers + 1

		end

	end
}

SCORE_BOARD = vgui.RegisterTable( SCORE_BOARD, "EditablePanel" )

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardShow( )
	Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

	if ( !IsValid( g_Scoreboard ) ) then
		g_Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
	end

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Show()
		g_Scoreboard:MakePopup()
		g_Scoreboard:SetKeyboardInputEnabled( false )
		local x,y,w,h = g_Scoreboard:GetBounds()
		local extra = 100
		ShowScreenDistortions(5, 0.25, x-extra,y-extra,w+extra*2,h+extra*2)
	end

end

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardHide( )
	Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Hide()
		local x,y,w,h = g_Scoreboard:GetBounds()
		local extra = 100
		ShowScreenDistortions(5, 0.25, x-extra,y-extra,w+extra*2,h+extra*2)
	end

end

--[[---------------------------------------------------------
	Name: gamemode:HUDDrawScoreBoard( )
	Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()
end

--g_Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
--g_Scoreboard:Hide()