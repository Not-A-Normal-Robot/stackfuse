require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'
local Grid = require 'tetris.components.grid'

local Bag7Randomizer = require 'tetris.randomizers.bag7'

local HyperPrism = GameMode:extend()

HyperPrism.name = "Hyper Prism"
HyperPrism.hash = "HyperPrism"
HyperPrism.tagline = "Taste the rainbow again, motherfucker"

function HyperPrism:new()
	HyperPrism.super:new()

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

function HyperPrism:getLevel()
	if self.lines < 150 then
		return math.floor(self.lines / 15) + 1
	elseif self.lines == 150 then
		return 10
	elseif self.vibecheck then
		return 5
	end
end

function HyperPrism:getARE()
	return 16
end

function HyperPrism:getLineARE()
	return 16
end

function HyperPrism:getDasLimit()
	return 12
end

function HyperPrism:getLineClearDelay()
	return 16
end

function HyperPrism:getLockDelay()
	return 30
end

function HyperPrism:getGravity()
	local level = self.level
	if (level < 2) then return 1
	elseif (level < 3) then return 2
	elseif (level < 4) then return 5
	else return 20
	end
end

function HyperPrism:getNextLineRequirement()
  local line_strings = {"SINGLE", "DOUBLE", "TRIPLE", "QUAD", "TRIPLE", "DOUBLE"}
  if self.linecheck <= 6 then
	  return line_strings[self.linecheck]
  elseif self.level >= 6 then
	  return "ALL CLEAR"
  else
	  return "well something went wrong"
  end
end


function HyperPrism:advanceOneFrame()
	if self.lines >= 75 then
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
	self.level >= 5 and self.sectioncheck == 3 then
		playSEOnce("caution")
		self.sectioncheck = self.sectioncheck + 1
	end
	return true
end

function HyperPrism:onPieceEnter()

end

function HyperPrism:onPieceLock(piece, cleared_row_count)
	playSE("lock")
end

function HyperPrism:onLineClear(cleared_row_count)
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
			if self.lines == 75 then
				love.audio.stop(sounds.erase)
				playSEOnce("finalerase")
			end
		else
			love.audio.stop(sounds.erase)
			playSEOnce("wrongerase")
			local fucked_lines = self.fuckedlines + 1
			self.fuckedlines = fucked_lines
			local garbo = self.garbagecount + cleared_row_count
			self.garbagecount = garbo
			print(self.fuckedlines)
		end
	end
end

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

function HyperPrism:drawGrid()
	self.grid:draw()
	self:drawGhostPiece(ruleset)
end

function HyperPrism:drawScoringInfo()
	HyperPrism.super.drawScoringInfo(self)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_New)
	love.graphics.printf("NEXT", 590, 8, 80, "center")
	love.graphics.printf("CLEAR TARGET", 776, 200, 240, "left")
	love.graphics.printf("LINES", 776, 340, 80, "left")
	love.graphics.printf("LOOP", 776, 480, 80, "left")

	love.graphics.setFont(font_New_Big)
	love.graphics.printf(self:getNextLineRequirement(), 776, 232, 240, "left")
	love.graphics.printf(self.lines, 776, 372, 120, "left")
	if self.level >= 6 then
		love.graphics.printf("5", 776, 512, 120, "left")
	else
		love.graphics.printf(self.level, 776, 512, 120, "left")
	end

	if self.fuckedlines < 1 then
		if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
			love.graphics.setColor(0.7, 0.7, 1, 1)
		else
			love.graphics.setColor(0.8, 0.8, 1, 1)
		end
	else
		love.graphics.setColor(0, 1, 0, 1)
	end
	love.graphics.rectangle("fill", 501, 600, 6, -math.min(((self.level/5)*480),480))


	love.graphics.setFont(font_New_Big)
	if self.fuckedlines < 1 then
		if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
			love.graphics.setColor(0.7, 0.7, 1, 1)
		else
			love.graphics.setColor(0.8, 0.8, 1, 1)
		end
	elseif self.fuckedlines < 16 then
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

function HyperPrism:getBackground()
	if self.hypermode then
		return 1
	else
		return 0
	end
end

function HyperPrism:getHighscoreData()
	return {
		level = self.level,
		frames = self.frames,
	}
end

return HyperPrism
