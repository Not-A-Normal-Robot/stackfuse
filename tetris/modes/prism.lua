require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'
local Grid = require 'tetris.components.grid'

local Bag7Randomizer = require 'tetris.randomizers.bag7'

local prism = GameMode:extend()

prism.name = "Prism"
prism.hash = "Prism"
prism.tagline = "Taste the rainbow, motherfucker"

function prism:new()
	prism.super:new()

	self.level = 1
	self.lines = 0
	self.roll_frames = 0
	self.combo = 1
	self.bravos = 0
	self.randomizer = Bag7Randomizer()

	--mode specific variables
	self.bgmstarter = 0
	self.linecheck = 1
	self.fuckedlines = 0
	self.garbagecount = 0
	self.sectioncheck = 0
	self.hypermode = false
	self.vibecheck = false

	self.lock_drop = true
	self.lock_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 3

end

function prism:getLevel()
	if self.lines < 150 then
		return math.floor(self.lines / 15) + 1
	elseif self.lines == 150 then
		return 10
	elseif self.vibecheck then
		return 5
	end
end

function prism:getARE()
	return 16
end

function prism:getLineARE()
	return 16
end

function prism:getDasLimit()
	return 12
end

function prism:getLineClearDelay()
	return 16
end

function prism:getLockDelay()
	return 30
end

function prism:getGravity()
	local level = self.level
	if (level < 2) then return 1/32
	elseif (level < 3) then return 1/16
	elseif (level < 4) then return 1/12
	elseif (level < 5) then return 1/10
	elseif (level < 7) then return 1/6
	elseif (level < 8) then return 1/4
	elseif (level < 10) then return 1/2
	else return 1
	end
end

function prism:getNextLineRequirement()
  local line_strings = {"SINGLE", "DOUBLE", "TRIPLE", "QUAD", "TRIPLE", "DOUBLE"}
  if self.linecheck <= 6 then return line_strings[self.linecheck] else return "wat" end
end


function prism:advanceOneFrame()
	--torikan check
	if not self.hypermode then
		if self.lines >= 75 and self.frames <= 8699 and self.fuckedlines == 0 then
			self.hypermode = true
			love.audio.stop(sounds.erase)
			playSEOnce("finalerase")
			--switchBGMLoop("hyper")
		elseif self.lines >= 75 and self.fuckedlines >= 1 or self.lines >= 75 and self.frames >= 8700 then
			self.vibecheck = true --TODO implement custom game over screen for missing the requirement (noted by this variable being true)
			self.game_over = true
		end
	end
	if self.lines >= 150 then
		self.sectioncheck = 30
		if self.sectioncheck == 30 then
			love.audio.stop(sounds.erase)
			playSEOnce("finalerase")
			self.sectioncheck = 31
		end
		self.clear = true
		self.completed = true
		--fadeoutBGM(2)
	end
	if self.completed then -- GG pattern time
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
		--switchBGMLoop("hard")
	end
	if self.level >= 2 and self.sectioncheck == 0 or
	self.level >= 3 and self.sectioncheck == 1 or
	self.level >= 4 and self.sectioncheck == 2 or
	self.level >= 5 and self.sectioncheck == 3 or
	self.level >= 7 and self.sectioncheck == 4 or
	self.level >= 8 and self.sectioncheck == 5 or
	self.level >= 9 and self.sectioncheck == 6 or
	self.level >= 10 and self.sectioncheck == 7 or
	self.level >= 11 and self.sectioncheck == 8 then
		playSEOnce("caution")
		self.sectioncheck = self.sectioncheck + 1
	end
	return true
end

function prism:onPieceEnter()
	if self.garbagecount > 0 then
		self.grid:copyBottomRow()
		playSEOnce("garbage")
		self.garbagecount = 0
	end
end

function prism:onPieceLock(piece, cleared_row_count)
	playSE("lock")
end

-- TODO torikan at 75 lines. conditions: no false lines, certain time limit

function prism:onLineClear(cleared_row_count)
	if not self.clear then
		if self.linecheck == 1 and cleared_row_count == 1 or
		self.linecheck == 2 and cleared_row_count == 2 or
		self.linecheck == 3 and cleared_row_count == 3 or
		self.linecheck == 4 and cleared_row_count == 4 or
		self.linecheck == 5 and cleared_row_count == 3 or
		self.linecheck == 6 and cleared_row_count == 2 then
			local new_lines = self.lines + cleared_row_count
			self.lines = new_lines
			self.level = self:getLevel()
			if self.linecheck >= 6 then
				self.linecheck = 1
			else
				self.linecheck = self.linecheck + 1
			end
			if self.lines == 73 then
				--fadeoutBGM(1)
			end
			--[[if self.lines == 75 then
				love.audio.stop(sounds.erase)
				playSEOnce("finalerase")
			end]]
			if self.lines >= 150 then
				love.audio.stop(sounds.erase)
				playSEOnce("finalerase")
			end
		else
			love.audio.stop(sounds.erase)
			playSEOnce("wrongerase")
			local fucked_lines = self.fuckedlines + cleared_row_count
			self.fuckedlines = fucked_lines
			local garbo = self.garbagecount + cleared_row_count
			self.garbagecount = garbo
		end
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

function GameMode:onGameOver()
	switchBGM(nil)
	love.audio.stop(sounds.powermode)
	love.graphics.setColor(1, 1, 1, (self.game_over_frames / 10)-2)
	if self.game_over_frames == 30 then
		playSEOnce("topout")
	end
	if self.vibecheck then
		love.graphics.draw(misc_graphics["ded2"], 0, 0)
	else
		love.graphics.draw(misc_graphics["ded"], 0, 0)
	end
end

function prism:drawGrid()
	self.grid:draw()
	self:drawGhostPiece(ruleset)
end

function prism:drawScoringInfo()
	prism.super.drawScoringInfo(self)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_New)
	love.graphics.printf("NEXT", 590, 8, 80, "center")
	love.graphics.printf("CLEAR TARGET", 776, 200, 240, "left")
	love.graphics.printf("LINES", 776, 340, 80, "left")
	love.graphics.printf("LOOP", 776, 480, 80, "left")

	love.graphics.setFont(font_New_Big)
	love.graphics.printf(self:getNextLineRequirement(), 776, 232, 240, "left")
	love.graphics.printf(self.lines, 776, 372, 120, "left")
	love.graphics.printf(self.level, 776, 512, 120, "left")


	--bar
	if self.hypermode then
		if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
			love.graphics.setColor(0.7, 0.7, 1, 1)
		else
			love.graphics.setColor(0.8, 0.8, 1, 1)
		end
		love.graphics.rectangle("fill", 501, 600, 6, -math.min((((self.level/5)-1)*480),480))
	else
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.rectangle("fill", 501, 600, 6, -math.min(((self.level/5)*480),480))
	end


	love.graphics.setFont(font_New_Big)
	if self.fuckedlines == 0 and self.frames <= 8699 and not self.hypermode then
		if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
			love.graphics.setColor(1, 1, 1, 1)
		else
			love.graphics.setColor(1, 1, 0.4, 1)
		end
	elseif self.hypermode then
		if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
			love.graphics.setColor(0.7, 0.7, 1, 1)
		else
			love.graphics.setColor(0.8, 0.8, 1, 1)
		end
	else
		love.graphics.setColor(1, 1, 1, 1)
	end
	love.graphics.printf(formatTime(self.frames), 470, 620, 320, "center")

end

function prism:getBackground()
	if self.hypermode then
		return 1
	else
		return 0
	end
end

function prism:getHighscoreData()
	return {
		level = self.level,
		frames = self.frames,
	}
end

return prism
