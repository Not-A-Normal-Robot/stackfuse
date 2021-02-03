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

	self.lock_drop = false
	self.enable_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 3
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
	if (level < 500) then return 15
	elseif (level < 800) then return 12
	elseif (level < 1000) then return 10
	elseif (level < 1200) then return 8
	elseif (level < 1300) then return 7
	elseif (level < 1400) then return 6
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
	elseif (level < 900) then return 11
	elseif (level < 1000) then return 10
	elseif (level < 1100) then return 9
	elseif (level < 1200) then return 8
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
		else
		self.multiplier = (math.min (math.max(2, self.multiplier - self.drain), 50))
		end
		self.time_limit = math.max(self.time_limit - 1, 0)
        if self.time_limit <= 0 and self.piece == nil then
            self.game_over = true
        end
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

function Powerstack:drawGrid()
	self.grid:draw()
	self:drawGhostPiece(ruleset)
end

function Powerstack:drawScoringInfo()
	Powerstack.super.drawScoringInfo(self)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_NEC)
	love.graphics.printf("NEXT", 129, 8, 40, "left")
	love.graphics.printf("MULTIPLIER", 256, 128, 120, "left")
	love.graphics.printf("LEVEL", 256, 312, 40, "left")	

	love.graphics.setFont(font_NEC_Big)
	love.graphics.printf("x"..string.format("%.3f",(self.multiplier/10)), 256, 160, 120, "left")
	love.graphics.printf(self.level, 256, 336, 80, "left")
	
	leftsidebarUnderlay = love.graphics.newImage("res/img/leftsidebarUnderlay.png")
	love.graphics.draw(leftsidebarUnderlay, 42, 80)
	
	
	if self.powermode then
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle("fill", 42, 400, 8, -math.min((self.multiplier*6.4),321))
	else
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.rectangle("fill", 42, 400, 8, -math.min((self.multiplier*6.4),321))
	end 
	love.graphics.setColor(1, 1, 1, 1)
	
	leftsidebar = love.graphics.newImage("res/img/leftsidebar.png")
	love.graphics.draw(leftsidebar, 42, 80)

	
	love.graphics.setFont(font_newBiggerFont)
	love.graphics.printf(formatTime(self.time_limit), 65, 416, 160, "center")
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
