require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'
local Grid = require 'tetris.components.grid'

local Bag7Randomizer = require 'tetris.randomizers.bag7'

local Liftoff = GameMode:extend()

Liftoff.name = "Liftoff"
Liftoff.hash = "Liftoff"
Liftoff.tagline = "Have you ever tried maxing out in a Rocket? Well, good luck!"

function Liftoff:new()
	Liftoff.super:new()

	self.level = 1
	self.lines = 0
	self.roll_frames = 0
	self.combo = 1
	self.bravos = 0
	self.randomizer = Bag7Randomizer()
	self.piecelimit = 0

	self.lock_drop = false
	self.enable_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 3
	self.sectioncheck = 0
end

function Liftoff:getPieceLimit()
	local level = self.level
	if (level < 3) then return 30
	elseif (level < 5) then return 28
	elseif (level < 9) then return 25
	elseif (level < 10) then return 22
	elseif (level < 12) then return 20
	elseif (level < 32) then return 18
	elseif (level < 38) then return 17
	elseif (level < 45) then return 15
	elseif (level < 50) then return 13
	else return 10
	end
end

function Liftoff:getMultiplier()
	local level = self.level
	if (level < 3) then return 1
	elseif (level < 5) then return 2
	elseif (level < 9) then return 3
	elseif (level < 10) then return 4
	elseif (level < 12) then return 5
	elseif (level < 32) then return 6
	elseif (level < 38) then return 7
	elseif (level < 45) then return 8
	elseif (level < 50) then return 9
	else return 10
	end
end

function Liftoff:getLevel()
	if self.lines < 300 then
		return math.floor(self.lines / 6) + 1
	else
		return 50
	end
end

function Liftoff:getARE()
	return 16
end

function Liftoff:getLineARE()
	return 16
end

function Liftoff:getDasLimit()
	return 12
end

function Liftoff:getLineClearDelay()
	return 16
end

function Liftoff:getLockDelay()
	local level = self.level
	if (level < 6) then return 30 --level 1-5
	elseif (level < 9) then return 27 --lv6-8
	elseif (level < 10) then return 30 --lv9
	elseif (level < 20) then return 25 --lv10-19
	elseif (level < 22) then return 22 --lv20-21
	elseif (level < 25) then return 20 --lv22-24
	elseif (level < 28) then return 30 --lv25-27
	elseif (level < 30) then return 25 --lv 28-29
	else return 20 --level 30+
	end
end

function Liftoff:getGravity()
	local level = self.level
	if (level < 2) then return 1/32
	elseif (level < 3) then return 1/16
	elseif (level < 4) then return 1/10
	elseif (level < 5) then return 1/8
	elseif (level < 6) then return 1/4
	elseif (level < 8) then return 1/2
	elseif (level < 9) then return 1
	elseif (level < 10) then return 1/8
	elseif (level < 25) then return 1
	else return 2
	end
end



function Liftoff:advanceOneFrame()
	if self.score >= 999999 then
		self.clear = true
		self.completed = true
	end
	if self.completed then
			local emptyGarbage = {"e", "e", "e", "e", "e", "e", "e", "e", "e", "e"}
			local letterGTopBottom = {"e", "e", "e", "", "", "", "", "e", "e", "e"}
			local letterG145 = {"e", "e", "", "e", "e", "e", "e", "", "e", "e"}
			local letterG2 = {"e", "e", "", "e", "e", "e", "e", "e", "e", "e"}
			local letterG3 = {"e", "e", "", "e", "e", "", "", "e", "e", "e"}
			self.grid:clear()
			self.grid:garbageRise(emptyGarbage)
			self.grid:garbageRise(emptyGarbage)
			self.grid:garbageRise(letterGTopBottom)
			self.grid:garbageRise(letterG145)
			self.grid:garbageRise(letterG2)
			self.grid:garbageRise(letterG3)
			self.grid:garbageRise(letterG145)
			self.grid:garbageRise(letterG145)
			self.grid:garbageRise(letterGTopBottom)
			self.grid:garbageRise(emptyGarbage)
			self.grid:garbageRise(emptyGarbage)
			self.grid:garbageRise(letterGTopBottom)
			self.grid:garbageRise(letterG145)
			self.grid:garbageRise(letterG2)
			self.grid:garbageRise(letterG3)
			self.grid:garbageRise(letterG145)
			self.grid:garbageRise(letterG145)
			self.grid:garbageRise(letterGTopBottom)
			self.grid:garbageRise(emptyGarbage)
			self.grid:garbageRise(emptyGarbage)
	elseif self.ready_frames == 0 then
		self.frames = self.frames + 1
	end
	if self.frames == 1 then
		--switchBGMLoop("hyper")
	end
	if self.level >= 2 and self.sectioncheck == 0 or
	self.level >= 3 and self.sectioncheck == 1 or
	self.level >= 4 and self.sectioncheck == 2 or
	self.level >= 5 and self.sectioncheck == 3 or
	self.level >= 6 and self.sectioncheck == 4 or
	self.level >= 8 and self.sectioncheck == 5 or
	self.level >= 9 and self.sectioncheck == 6 or -- 9 is slowdown, maybe implement elsewhere?
	self.level >= 10 and self.sectioncheck == 7 or -- begin 1G for real now
	self.level >= 15 and self.sectioncheck == 8 or
	self.level >= 20 and self.sectioncheck == 9 or
	self.level >= 22 and self.sectioncheck == 10 or
	self.level >= 25 and self.sectioncheck == 11 or -- begin 2G
	self.level >= 30 and self.sectioncheck == 12 or
	self.level >= 32 and self.sectioncheck == 13 or
	self.level >= 35 and self.sectioncheck == 14 or
	self.level >= 38 and self.sectioncheck == 15 or
	self.level >= 40 and self.sectioncheck == 16 or
	self.level >= 45 and self.sectioncheck == 17 or
	self.level >= 50 and self.sectioncheck == 17 then
		playSEOnce("caution")
		self.sectioncheck = self.sectioncheck + 1
	end
	return true
end

function Liftoff:onPieceEnter()

end

function Liftoff:onPieceLock(piece, cleared_row_count)
	local emptyGarbage = {"e", "e", "e", "e", "e", "e", "e", "e", "e", "e"}
	if self.piecelimit >= self:getPieceLimit() then
		self.grid:garbageRise(emptyGarbage)
		playSEOnce("garbage")
		self.piecelimit = 0
	end
	self.piecelimit = self.piecelimit + 1
	playSE("lock")
end

local cleared_row_score = {300, 900, 2200, 3800}

function Liftoff:onLineClear(cleared_row_count)
	if not self.clear then
		local new_score = math.min(self.score + (cleared_row_score[cleared_row_count]*self:getMultiplier()), 999999)
		self.score = new_score
		local new_lines = self.lines + cleared_row_count
		self.lines = new_lines
		local new_piecelimit = self.piecelimit - cleared_row_count
		self.piecelimit = math.max(new_piecelimit, 0)
		self.level = self:getLevel()
	end
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

function Liftoff:drawGrid()
	self.grid:draw()
	self:drawGhostPiece(ruleset)
end

function Liftoff:drawScoringInfo()
	Liftoff.super.drawScoringInfo(self)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_New)
	love.graphics.printf("NEXT", 590, 8, 80, "center")
	love.graphics.printf("SCORE", 776, 200, 240, "left")
	love.graphics.printf("LINES", 776, 340, 80, "left")
	love.graphics.printf("LEVEL", 776, 480, 80, "left")

	love.graphics.setFont(font_New_Big)
	love.graphics.printf(self.score, 776, 232, 240, "left")
	love.graphics.printf(self.lines, 776, 372, 120, "left")
	love.graphics.printf(self.level, 776, 512, 120, "left")

	if (self:getPieceLimit()-self.piecelimit) <= 3 and (self:getPieceLimit()-self.piecelimit) ~= 0 then
	love.graphics.setColor(1, 1, 1, 1)
	elseif self:getPieceLimit() == self.piecelimit then
	love.graphics.setColor(1, 0, 0, 1)
	else
	love.graphics.setColor(0, 1, 0, 1)
	end
	love.graphics.rectangle("fill", 501, 600, 6, -math.min(((self.piecelimit/self:getPieceLimit())*480),480))


	love.graphics.setFont(font_New_Big)
	if self.level >=25 then
		if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
			love.graphics.setColor(1, 1, 1, 1)
		else
			love.graphics.setColor(1, 1, 0.4, 1)
		end
	else
		love.graphics.setColor(1, 1, 1, 1)
	end
	love.graphics.printf(formatTime(self.frames), 470, 620, 320, "center")

end

function Liftoff:getBackground()
	return math.floor(self.level / 5)
end

function Liftoff:getHighscoreData()
	return {
		score = self.score,
		level = self.level,
		frames = self.frames,
		lines = self.lines,
	}
end

return Liftoff
