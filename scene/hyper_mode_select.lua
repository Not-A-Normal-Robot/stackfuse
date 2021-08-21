local HyperModeSelectScene = Scene:extend()

HyperModeSelectScene.title = "Hyper Mode"

current_mode = 1
current_ruleset = 1

function HyperModeSelectScene:new()
	self.menu_state = {
		mode = current_mode,
		ruleset = current_ruleset,
		select = "mode",
	}
	self.secret_inputs = {
		rotate_left = false,
		rotate_left2 = false,
		rotate_right = false,
		rotate_right2 = false,
		rotate_180 = false,
		hold = false,
	}
	DiscordRPC:update({
		details = "In menus",
		state = "Choosing a mode",
	})
end

function HyperModeSelectScene:update()
	switchBGM(nil) -- experimental
end

function HyperModeSelectScene:render()
	love.graphics.draw(
		backgrounds["game_config"],
		0, 0, 0,
		1, 1
	)

	if self.menu_state.select == "mode" then
		love.graphics.setColor(1, 1, 1, 0.5)
	elseif self.menu_state.select == "ruleset" then
		love.graphics.setColor(1, 1, 1, 0.25)
	end
	love.graphics.rectangle("fill", 20, 358, 600, 72)

	if self.menu_state.select == "mode" then
		love.graphics.setColor(1, 1, 1, 0.25)
	elseif self.menu_state.select == "ruleset" then
		love.graphics.setColor(1, 1, 1, 0.5)
	end
	love.graphics.rectangle("fill", 660, 358, 600, 72)

	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_New_Big)
	for idx, mode in pairs(hyper_game_modes) do
		if(idx >= self.menu_state.mode-9 and idx <= self.menu_state.mode+9) then
			love.graphics.setColor(0, 0, 0, 0.5)
			love.graphics.printf(mode.name, 40, 360 - (80*(self.menu_state.mode)) + 80 * idx, 800, "left")
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.printf(mode.name, 38, (360 - (80*(self.menu_state.mode)) + 80 * idx) - 2, 800, "left")
		end
	end
	for idx, ruleset in pairs(rulesets) do
		if(idx >= self.menu_state.ruleset-9 and idx <= self.menu_state.ruleset+9) then
			love.graphics.setColor(0, 0, 0, 0.5)
			love.graphics.printf(ruleset.name, 680, (360 - 80*(self.menu_state.ruleset)) + 80 * idx, 960, "left")
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.printf(ruleset.name, 678, ((360 - 80*(self.menu_state.ruleset)) + 80 * idx) - 2, 960, "left")
		end
	end
	love.graphics.draw(misc_graphics["modeshadow"], 0, 0)

	love.graphics.setFont(font_New_Big)
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.printf("Select your mode", 250, 40, 800, "center")
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.printf("Select your mode", 248, 38, 800, "center")

	love.audio.stop(sounds.powermode) --in case someone quits out of Powerstack with Power Mode active
	love.audio.stop(sounds.topout) -- in case someone quits out of game overing early
end

function HyperModeSelectScene:onInputPress(e)
	if e.input == "rotate_left" or e.scancode == "return" then
		current_mode = self.menu_state.mode
		current_ruleset = self.menu_state.ruleset
		config.current_mode = current_mode
		config.current_ruleset = current_ruleset
		--playSE("mode_decide") - i'll find a better sound for this at some point!
		saveConfig()
		scene = GameScene(hyper_game_modes[self.menu_state.mode], rulesets[self.menu_state.ruleset], self.secret_inputs)
	elseif e.input == "up" or e.scancode == "up" then
		self:changeOption(-1)
		playSE("cursor")
	elseif e.input == "down" or e.scancode == "down" then
		self:changeOption(1)
		playSE("cursor")
	elseif e.input == "left" or e.input == "right" or e.scancode == "left" or e.scancode == "right" then
		self:switchSelect()
		playSE("cursor_lr")
	elseif e.input == "rotate_right" or e.scancode == "delete" or e.scancode == "backspace" or e.scancode == "escape" then
		playSE("menu_back")
		scene = TitleScene()
	elseif e.input then
		self.secret_inputs[e.input] = true
	end
end

function HyperModeSelectScene:onInputRelease(e)
	if e.input == "hold" or (e.input and string.sub(e.input, 1, 7) == "rotate_") then
		self.secret_inputs[e.input] = false
	end
end

function HyperModeSelectScene:changeOption(rel)
	if self.menu_state.select == "mode" then
		self:changeMode(rel)
	elseif self.menu_state.select == "ruleset" then
		self:changeRuleset(rel)
	end
end

function HyperModeSelectScene:switchSelect(rel)
	if self.menu_state.select == "mode" then
		self.menu_state.select = "ruleset"
	elseif self.menu_state.select == "ruleset" then
		self.menu_state.select = "mode"
	end
end

function HyperModeSelectScene:changeMode(rel)
	local len = table.getn(hyper_game_modes)
	self.menu_state.mode = (self.menu_state.mode + len + rel - 1) % len + 1
end

function HyperModeSelectScene:changeRuleset(rel)
	local len = table.getn(rulesets)
	self.menu_state.ruleset = (self.menu_state.ruleset + len + rel - 1) % len + 1
end

return HyperModeSelectScene
