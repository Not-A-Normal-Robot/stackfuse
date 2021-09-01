require 'funcs'

local GameMode = require 'tetris.modes.gamemode'

local Bag7Randomizer = require 'tetris.randomizers.bag7'

local G_Lock = GameMode:extend()

G_Lock.name = "G-Lock"
G_Lock.hash = "G-Lock"
G_Lock.tagline = "The speeds fluctuate rapidly! Use the increased gravity and downstack faster!"

function G_Lock:new()
	self.super:new()

	self.pieces = 0

	self.randomizer = Bag7Randomizer()
	self.lock_drop = true
	self.lock_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 4
end

function G_Lock:getARE()
    	return 16
end

function G_Lock:getLineARE()
	--[[if (self.pieces < 250) then return 20
    elseif (self.pieces < 275) then return 18
    elseif (self.pieces < 285) then return 18
    elseif (self.pieces < 305) then return 14
    elseif (self.pieces < 315) then return 16
    elseif (self.pieces < 340) then return 12
    elseif (self.pieces < 350) then return 14
    elseif (self.pieces < 380) then return 12
    elseif (self.pieces < 395) then return 12
    elseif (self.pieces < 430) then return 10
    elseif (self.pieces < 445) then return 10
    else return 8
	end]]
	if self:getGSectionState() then
		return 10
	else
		return self:getARE()
	end

end

function G_Lock:getDasLimit()
	if self:getGSectionState() then
		return 8
	else
		return 12
	end
	--[[
	if (self.pieces < 195) then return 16
    elseif (self.pieces < 235) then return 14
    elseif (self.pieces < 250) then return 16
    elseif (self.pieces < 275) then return 14
    elseif (self.pieces < 285) then return 14
    elseif (self.pieces < 305) then return 14
    elseif (self.pieces < 315) then return 14
    elseif (self.pieces < 340) then return 12
    elseif (self.pieces < 350) then return 12
    elseif (self.pieces < 380) then return 12
    elseif (self.pieces < 395) then return 12
    else return 10
	end]]
end

function G_Lock:getLineClearDelay()
	--[[if (self.pieces < 275) then return 25
    elseif (self.pieces < 285) then return 18
    elseif (self.pieces < 305) then return 20
    elseif (self.pieces < 315) then return 18
    elseif (self.pieces < 340) then return 18
    elseif (self.pieces < 350) then return 16
    elseif (self.pieces < 380) then return 16
    elseif (self.pieces < 395) then return 16
    elseif (self.pieces < 430) then return 12
    elseif (self.pieces < 445) then return 14
    elseif (self.pieces < 475) then return 10
    else return 8
	end]]
	if self:getGSectionState() then
		return 4
	else
		return 25
	end
end

function G_Lock:getLockDelay()
        if (self.pieces < 395) then return 30
    elseif (self.pieces < 430) then return 28
    elseif (self.pieces < 445) then return 30
    elseif (self.pieces < 475) then return 25
    else return 23
    end
end

function G_Lock:getGravity()
        if (self.pieces < 20)  then return 64/256
    elseif (self.pieces < 50)  then return 2
    elseif (self.pieces < 65)  then return 64/256
    elseif (self.pieces < 115) then return 4
    elseif (self.pieces < 130) then return 128/256
    elseif (self.pieces < 180) then return 5
    elseif (self.pieces < 195) then return 1
    elseif (self.pieces < 235) then return 10
    elseif (self.pieces < 250) then return 2
    elseif (self.pieces < 275) then return 20
    elseif (self.pieces < 285) then return 2
    elseif (self.pieces < 305) then return 20
    elseif (self.pieces < 315) then return 3
    elseif (self.pieces < 340) then return 20
    elseif (self.pieces < 350) then return 3
    elseif (self.pieces < 380) then return 20
    elseif (self.pieces < 395) then return 4
    elseif (self.pieces < 430) then return 20
    elseif (self.pieces < 445) then return 5
    else return 20
    end
end

function G_Lock:advanceOneFrame()
	if self.ready_frames == 0 then
		self.frames = self.frames + 1
	end
	if self.frames == 1 then
		--switchBGMLoop("hyper")
	end
	if self:getGSectionState() then
		playSEOnce("powermode")
	else
		love.audio.stop(sounds.powermode)
	end
	return true
end

function G_Lock:onPieceLock()
	self.super:onPieceLock()
	self.pieces = self.pieces + 1
	if self.pieces == 20 or
		self.pieces == 65 or
		self.pieces == 130 or
		self.pieces == 195 or
		self.pieces == 250 or
		self.pieces == 285 or
		self.pieces == 315 or
		self.pieces == 350 or
		self.pieces == 395 or
		self.pieces == 445 or
		self.pieces == 475 then
	playSEOnce("garbage")
	end

	if self.pieces == 50 or
		self.pieces == 115 or
		self.pieces == 180 or
		self.pieces == 235 or
		self.pieces == 275 or
		self.pieces == 305 or
		self.pieces == 340 or
		self.pieces == 380 or
		self.pieces == 430 then
	playSEOnce("danger")
	end

	if (self:getSectionEndLevel()-self.pieces) <= 3 and (self:getSectionEndLevel()-self.pieces) ~= 0 then
	playSE("singlecaution")
	end

	if self.pieces == 500 then
		self.completed = true
		love.audio.stop(sounds.erase)
		love.audio.stop(sounds.powermode)
		playSEOnce("finalerase")
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
	end
end

function G_Lock:drawGrid()
	self.grid:draw()
	self:drawGhostPiece()
end

function G_Lock:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_New)
	love.graphics.printf("NEXT", 590, 8, 80, "center")
	love.graphics.printf("SECTIONS CLEARED", 776, 168, 400, "left")
	love.graphics.printf("PIECES", 776, 480, 100, "left")
	love.graphics.setFont(font_New_Big)

	if self:getGSection() == 11 then
		love.graphics.printf("ALL CLEAR", 776, 192, 400, "left")
	else
		love.graphics.printf(self:getGSection(), 776, 192, 180, "left")
	end

	love.graphics.printf(self.pieces, 702, 504, 160, "right")
	love.graphics.printf(self:getSectionEndLevel(), 702, 555, 160, "right")

	love.graphics.setFont(font_New_Big)
	love.graphics.printf(formatTime(self.frames), 470, 620, 320, "center")


	if self:getGSectionState() then
		if (self:getSectionEndLevel()-self.pieces) <= 3 and (self:getSectionEndLevel()-self.pieces) ~= 0 then
			if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
				love.graphics.setColor(1, 1, 1, 1)
			else
				love.graphics.setColor(0.9, 0.9, 0.9, 1)
			end
		elseif self:getSectionEndLevel() == self.pieces then
			if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(0.9, 0.9, 0.9, 1)
			end
		else
			if (self.frames % 4) == 0 or (self.frames % 4) == 1 then
				love.graphics.setColor(1, 1, 1, 1)
			else
				love.graphics.setColor(0.95, 0.95, 0.95, 1)
			end
		end
	else
		if (self:getSectionEndLevel()-self.pieces) <= 3 and (self:getSectionEndLevel()-self.pieces) ~= 0 then
			love.graphics.setColor(1, 1, 1, 1)
		elseif self:getSectionEndLevel() == self.pieces then
			love.graphics.setColor(1, 0, 0, 1)
		else
			love.graphics.setColor(0, 1, 0, 1)
		end
	end
--[[
	if (self:getSectionEndLevel()-self.pieces) <= 3 and (self:getSectionEndLevel()-self.pieces) ~= 0 then
		love.graphics.setColor(1, 1, 1, 1)
	elseif self:getSectionEndLevel() == self.pieces then
		love.graphics.setColor(1, 0, 0, 1)
	else
		love.graphics.setColor(0, 1, 0, 1)
	end]]
	--how bar
	if self:getGSectionState() then
		love.graphics.rectangle("fill", 501, 600, 6, -math.min((((self:getSectionEndLevel()-self.pieces)/(self:getSectionEndLevel()-self:getPreviousSectionEnd()+1))*480),480))
	else
		love.graphics.rectangle("fill", 501, 600, 6, -math.min((((self.pieces-self:getPreviousSectionEnd())/(self:getSectionEndLevel()-self:getPreviousSectionEnd()-1))*480),480))
	end

	if self.completed then
		if self.frames <= 16200 then
			love.graphics.setColor(1, 0.7, 0, 1)
		elseif self.frames <= 14400 then
			love.graphics.setColor(0, 0, 1, 1)
		else
			love.graphics.setColor(0, 1, 0, 1)
		end
	love.graphics.rectangle("fill", 501, 600, 6, -480)
	end


end

function G_Lock:getSectionEndLevel()
	    if self.pieces < 20 then return 20
	elseif self.pieces < 50 then return 50
    	elseif self.pieces < 65 then return 65
	elseif self.pieces < 115 then return 115
    	elseif self.pieces < 130 then return 130
	elseif self.pieces < 180 then return 180
    	elseif self.pieces < 195 then return 195
	elseif self.pieces < 235 then return 235
    	elseif self.pieces < 250 then return 250
	elseif self.pieces < 275 then return 275
    	elseif self.pieces < 285 then return 285
	elseif self.pieces < 305 then return 305
    	elseif self.pieces < 315 then return 315
	elseif self.pieces < 340 then return 340
	elseif self.pieces < 350 then return 350
	elseif self.pieces < 380 then return 380
    	elseif self.pieces < 395 then return 395
	elseif self.pieces < 430 then return 430
    	elseif self.pieces < 445 then return 445
	elseif self.pieces < 475 then return 475
	else return 500 end
end

function G_Lock:getPreviousSectionEnd()
	    if self.pieces < 20 then return 0
	elseif self.pieces < 50 then return 20
	elseif self.pieces < 65 then return 50
	elseif self.pieces < 115 then return 65
    elseif self.pieces < 130 then return 115
	elseif self.pieces < 180 then return 130
    elseif self.pieces < 195 then return 180
	elseif self.pieces < 235 then return 195
    elseif self.pieces < 250 then return 235
	elseif self.pieces < 275 then return 250
    elseif self.pieces < 285 then return 275
	elseif self.pieces < 305 then return 285
    elseif self.pieces < 315 then return 305
	elseif self.pieces < 340 then return 315
	elseif self.pieces < 350 then return 340
	elseif self.pieces < 380 then return 350
    elseif self.pieces < 395 then return 380
	elseif self.pieces < 430 then return 395
    elseif self.pieces < 445 then return 430
	elseif self.pieces < 475 then return 445
	else return 475 end
end

function G_Lock:getGSectionState()
	if self.pieces < 20 then return false
    elseif self.pieces < 50 then return true
    elseif self.pieces < 65 then return false
    elseif self.pieces < 115 then return true
    elseif self.pieces < 130 then return false
    elseif self.pieces < 180 then return true
    elseif self.pieces < 195 then return false
    elseif self.pieces < 235 then return true
    elseif self.pieces < 250 then return false
    elseif self.pieces < 275 then return true
    elseif self.pieces < 285 then return false
    elseif self.pieces < 305 then return true
    elseif self.pieces < 315 then return false
    elseif self.pieces < 340 then return true
    elseif self.pieces < 350 then return false
    elseif self.pieces < 380 then return true
    elseif self.pieces < 395 then return false
    elseif self.pieces < 430 then return true
    elseif self.pieces < 445 then return false
    else return true
    end
end

function G_Lock:getGSection()
        if (self.pieces < 50)  then return 0
    elseif (self.pieces < 115) then return 1
    elseif (self.pieces < 180) then return 2
    elseif (self.pieces < 235) then return 3
    elseif (self.pieces < 275) then return 4
    elseif (self.pieces < 305) then return 5
    elseif (self.pieces < 340) then return 6
    elseif (self.pieces < 380) then return 7
    elseif (self.pieces < 430) then return 8
    elseif (self.pieces < 475) then return 9
    elseif (self.pieces < 500) then return 10
    else return 11 end
end

function G_Lock:getBackground()
	if self:getGSectionState() then return 4
	else return 7 end
end

function G_Lock:getHighscoreData()
	return {
		gsection = self:getGSection(),
		pieces = self.pieces,
		frames = self.frames,
	}
end

return G_Lock
