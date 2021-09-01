require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'
local Grid = require 'tetris.components.grid'

local Bag7Randomizer = require 'tetris.randomizers.bag7'

local HyperLiftoff = GameMode:extend()

HyperLiftoff.name = "Hyper Liftoff"
HyperLiftoff.hash = "HyperLiftoff"
HyperLiftoff.tagline = "WE HAVE REAHCED MXAIMUM VLELOICPY"

function HyperLiftoff:new()
	HyperLiftoff.super:new()

	self.level = 1
	self.lines = 0
	self.roll_frames = 0
	self.combo = 1
	self.bravos = 0
	self.randomizer = Bag7Randomizer()
	self.piecelimit = 0

	self.lock_drop = true
	self.lock_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 3
	self.sectioncheck = 0
end

function HyperLiftoff:getPieceLimit()
	local level = self.level
	if (level < 10) then return 10
	elseif (level < 20) then return 8
	else return 6
	end
end

function HyperLiftoff:getMultiplier()
	local level = self.level
	if (level < 10) then return 10
	elseif (level < 20) then return 12
	else return 16
	end
end

function HyperLiftoff:getLevel()
	if self.lines < 120 then
		return math.floor(self.lines / 6) + 1
	else
		return 20
	end
end

function HyperLiftoff:getARE()
	return 16
end

function HyperLiftoff:getLineARE()
	return 16
end

function HyperLiftoff:getDasLimit()
	return 12
end

function HyperLiftoff:getLineClearDelay()
	return 16
end

function HyperLiftoff:getLockDelay()
	local level = self.level
	return 20
end

function HyperLiftoff:getGravity()
	local level = self.level
	if (level < 10) then return 1
	elseif (level < 20) then return 2
	else return 20
	end
end



function HyperLiftoff:advanceOneFrame()
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

function HyperLiftoff:onPieceEnter()

end

function HyperLiftoff:onPieceLock(piece, cleared_row_count)
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

function HyperLiftoff:onLineClear(cleared_row_count)
	if not self.clear then
		local new_score = math.min(self.score + (cleared_row_score[cleared_row_count]*self:getMultiplier()), 999999)
		self.score = new_score
		local new_lines = self.lines + cleared_row_count
		self.lines = new_lines
		local new_piecelimit = self.piecelimit - (cleared_row_count + 1)
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

function HyperLiftoff:drawGrid()
	self.grid:draw()
	self:drawGhostPiece(ruleset)
end

function HyperLiftoff:drawScoringInfo()
	HyperLiftoff.super.drawScoringInfo(self)
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

function HyperLiftoff:getBackground()
	return math.floor(self.level / 5)
end

function HyperLiftoff:getHighscoreData()
	return {
		score = self.score,
		level = self.level,
		frames = self.frames,
		lines = self.lines,
	}
end

return HyperLiftoff
