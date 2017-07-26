
local flashtime = 0.5
local fadetime = 5
local col = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 1,
	[ "$pp_colour_mulg" ] = 1,
	[ "$pp_colour_mulb" ] = 1
}

function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.StartTime = CurTime()
	self.FadeOutTime = CurTime() + flashtime
	self.ColorCorrect = table.Copy(col)
	self.DieTime = CurTime() + fadetime + flashtime
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

function EFFECT:Render()

	local ct = CurTime()
	if ct < self.FadeOutTime then
		local val = ((1-(self.FadeOutTime-ct))/flashtime)
		self.ColorCorrect["$pp_colour_brightness"] = val
		self.ColorCorrect["$pp_colour_addr"] = val/1
	else
		local val = ((self.DieTime-ct)/fadetime)
		self.ColorCorrect["$pp_colour_brightness"] = val
		self.ColorCorrect["$pp_colour_addr"] = val/1
	end
	DrawColorModify(self.ColorCorrect)

end