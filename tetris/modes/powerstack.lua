require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'
local Grid = require 'tetris.components.grid'

local History4RollsRandomizer = require 'tetris.randomizers.history_4rolls'

local Powerstack = GameMode:extend()

Powerstack.name = "Powerstack"
Powerstack.hash = "Powerstack"
Powerstack.tagline = "Stack fast and efficiently to increase the power multiplier!"

function Powerstack:new()
	Powerstack.super:new()

	self.level = 0
	self.roll_frames = 0
	self.combo = 1
	self.bravos = 0
	self.multiplier = 10
	self.drain = 0.0002
	self.time_limit = 5400
	self.randomizer = History4RollsRandomizer()
	self.powermode = false
	self.lol = 0

	self.lock_drop = false
	self.enable_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 3
	self.sectioncheck = 0
end

function Powerstack:getARE()
	local level = self.level
	if (level < 350) then return 20
	elseif (level < 500) then return 16
	elseif (level < 800) then return 12
	elseif (level < 900) then return 11
	elseif (level < 1000) then return 10
	elseif (level < 1100) then return 9
	elseif (level < 1200) then return 8
	elseif (level < 1300) then return 7
	elseif (level < 1400) then return 6
	else return 5
	end
end

function Powerstack:getLineARE()
	local level = self.level
	if (level < 350) then return 20
	elseif (level < 500) then return 16
	elseif (level < 800) then return 12
	elseif (level < 900) then return 11
	elseif (level < 1000) then return 10
	elseif (level < 1100) then return 9
	elseif (level < 1200) then return 8
	elseif (level < 1300) then return 7
	elseif (level < 1400) then return 6
	else return 5
	end
end

function Powerstack:getDasLimit()
	local level = self.level
	if (level < 500) then return 12
	elseif (level < 800) then return 10
	elseif (level < 1000) then return 8
	elseif (level < 1200) then return 7
	elseif (level < 1300) then return 6
	elseif (level < 1400) then return 5
	else return 5
	end
end

function Powerstack:getLineClearDelay()
	local level = self.level
	if (level < 500) then return 5
	elseif (level < 800) then return 3
	elseif (level < 1000) then return 2
	else return 0
	end
end

function Powerstack:getLockDelay()
	local level = self.level
	if (level < 350) then return 30
	elseif (level < 400) then return 26
	elseif (level < 500) then return 23
	elseif (level < 600) then return 20
	elseif (level < 700) then return 17
	elseif (level < 800) then return 14
	elseif (level < 900) then return 13
	elseif (level < 1000) then return 12
	elseif (level < 1100) then return 11
	elseif (level < 1200) then return 9
	elseif (level < 1300) then return 7
	elseif (level < 1400) then return 6
	else return 5
	end
end

function Powerstack:getGravity()
	local level = self.level
	if (level < 50) then return 32/256
	elseif (level < 100) then return 128/256
	elseif (level < 200) then return 1
	elseif (level < 250) then return 3
	elseif (level < 300) then return 5
	else return 20
	end
end

function Powerstack:advanceOneFrame()
	if self.ready_frames == 0 then
		self.frames = self.frames + 1
		if self.multiplier >= 40 then
			self.powermode = true
		else
			self.powermode = false
		end
		if self.powermode then
		self.multiplier = (math.min (math.max(2, self.multiplier - (self.drain*4)), 50))
		playSEOnce("powermode")
		else
		self.multiplier = (math.min (math.max(2, self.multiplier - self.drain), 50))
		love.audio.stop(sounds.powermode)
		end
		self.time_limit = math.max(self.time_limit - 1, 0)
        if self.time_limit <= 0 and self.piece == nil then
            self.game_over = true
        end
		if self.lol == 0 and self.powermode then
			self.lol = 1
		elseif self.lol == 1 and not self.powermode then
			playSEOnce("danger")
			self.lol = 0
		end
	end
	if self.level >= 50 and self.sectioncheck == 0 or
	self.level >= 100 and self.sectioncheck == 1 or
	self.level >= 150 and self.sectioncheck == 2 or
	self.level >= 200 and self.sectioncheck == 3 or
	self.level >= 250 and self.sectioncheck == 4 or
	self.level >= 300 and self.sectioncheck == 5 or
	self.level >= 400 and self.sectioncheck == 6 or
	self.level >= 500 and self.sectioncheck == 7 or
	self.level >= 600 and self.sectioncheck == 8 or
	self.level >= 700 and self.sectioncheck == 9 or
	self.level >= 800 and self.sectioncheck == 10 or
	self.level >= 900 and self.sectioncheck == 11 or
	self.level >= 1000 and self.sectioncheck == 12 or
	self.level >= 1100 and self.sectioncheck == 13 or
	self.level >= 1200 and self.sectioncheck == 14 or
	self.level >= 1300 and self.sectioncheck == 15 or
	self.level >= 1400 and self.sectioncheck == 16 or
	self.level >= 1500 and self.sectioncheck == 17 then
		playSEOnce("caution")
		self.sectioncheck = self.sectioncheck + 1
	end
	return true
end

function Powerstack:onPieceEnter()
	self.level = self.level + 1

	local new_drain = 0.0002 + self.level / 40000
	self.drain = new_drain
end

local cleared_row_levels = {1, 2, 4, 6}
local cleared_row_levels_power = {2, 4, 8, 12}
local multiplieradder = {0, 2, 6, 16}
local timeadder = {0.1, 0.5, 1, 2}

function Powerstack:onLineClear(cleared_row_count)
	if self.powermode then
		love.audio.stop(sounds.erase)
		playSE("powererase")
		local new_level = self.level + cleared_row_levels_power[cleared_row_count]
		self.level = new_level
	else
		local new_level = self.level + cleared_row_levels[cleared_row_count]
		self.level = new_level
	end
	local new_multiplier = self.multiplier + multiplieradder[cleared_row_count]
	self.multiplier = new_multiplier
	local new_time_limit = self.time_limit + ((timeadder[cleared_row_count]*60)*(self.multiplier)/10)
	self.time_limit = new_time_limit
end

--[[forced move reset because i can do what i want. eat my ass
function GLock:whilePieceActive()
	if not self.piece:isMoveBlocked(self.grid, {x=-1, y=0}) and self.prev_inputs["left"]
	or not self.piece:isMoveBlocked(self.grid, {x=1, y=0}) and self.prev_inputs["right"] then
		self.piece.lock_delay = 0
	end
	if self.piece:isDropBlocked(self.grid) then
		self.time_active = self.time_active + 1
		if self.time_active >= 240 then self.piece.locked = true end
	end
end
]]

function Powerstack:drawGrid()
	self.grid:draw()
	self:drawGhostPiece(ruleset)
end

function Powerstack:drawScoringInfo()
	Powerstack.super.drawScoringInfo(self)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_NEC)
	love.graphics.printf("NEXT", 590, 8, 80, "center")
	love.graphics.printf("MULTIPLIER", 776, 168, 240, "left")
	love.graphics.printf("LEVEL", 776, 352, 80, "left")

	love.graphics.setFont(font_NEC_Big)
	love.graphics.printf("x"..string.format("%.3f",(self.multiplier/10)), 776, 200, 240, "left")
	love.graphics.printf(self.level, 776, 376, 120, "left")

	-- funky multiplier bar
	-- modulo 2 with frame counter for flashing
	if self.powermode then
	if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
		love.graphics.setColor(1, 0, 0, 1)
	else
		love.graphics.setColor(0.4, 0, 0, 1)
	end
	love.graphics.rectangle("fill", 501, 601, 6, -math.min((self.multiplier*9.6),480))
	else
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.rectangle("fill", 501, 600, 6, -math.min((self.multiplier*9.6),480))
	end
	love.graphics.setColor(1, 1, 1, 1)


	love.graphics.setFont(font_newBiggerFont)
	if self.time_limit <= 900 then
		if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
			love.graphics.setColor(1, 1, 1, 1)
		else
			love.graphics.setColor(1, 1, 0.4, 1)
		end
	end
	love.graphics.printf(formatTime(self.time_limit), 470, 620, 320, "center")

end

function Powerstack:getBackground()
	return math.floor(self.level / 100)
end

function Powerstack:getHighscoreData()
	return {
		level = self.level,
		frames = self.frames,
	}
end

return Powerstack
