local ConfigScene = Scene:extend()

ConfigScene.title = "Input Config"

require 'load.save'

local configurable_inputs = {
	"left",
	"right",
	"up",
	"down",
	"rotate_left",
	"rotate_right",
	"rotate_left2",
	"rotate_right2",
	"rotate_180",
	"hold",
	"retry",
	"pause",
}

local configurable_inputs_readable = {
	"Left",
	"Right",
	"Up",
	"Down",
	"Rotate left / Confirm in menus",
	"Rotate right / Back in menus",
	"Rotate left 2",
	"Rotate right 2",
	"Rotate 180",
	"Hold",
	"Retry",
	"Pause",
}

local function newSetInputs()
	local set_inputs = {}
	for i, input in ipairs(configurable_inputs) do
		set_inputs[input] = false
	end
	return set_inputs
end

function ConfigScene:new()
	self.input_state = 1
	self.set_inputs = newSetInputs()
	self.new_input = {}
	self.axis_timer = 0

	DiscordRPC:update({
		details = "In menus",
		state = "Changing input config",
	})
end

function ConfigScene:update()
end

function ConfigScene:render()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(
		backgrounds["input_config"],
		0, 0, 0,
		1, 1
	)
	--we are fancy fucks so we are gonna give you a box that tells you what input you're currently entering
	if self.input_state <= 12 then
		love.graphics.setColor(1, 1, 1, 0.5)
	else
		love.graphics.setColor(0, 0, 0, 0)
	end
	love.graphics.rectangle("fill", 200, 68 + 40 * self.input_state, 880, 40)

	love.graphics.setFont(font_New)
	--you know what we gotta do... draw the same stuff twice, first a bit transparent and then normal.
	love.graphics.setColor(0, 0, 0, 0.5)
	for i, input in ipairs(configurable_inputs_readable) do
		love.graphics.printf(input, 242, 72 + i * 40, 600, "left")
	end

	for i, input in ipairs(configurable_inputs) do
		if self.set_inputs[input] then
			love.graphics.printf(self.set_inputs[input], 642, 72 + i * 40, 400, "right")
		end
	end

	if self.input_state > table.getn(configurable_inputs) then
		love.graphics.printf("Inputs OK? Press return to confirm, delete/backspace to retry " .. (config.input and "or escape to cancel." or ""), 2, 622, 1280, "center")
	else
		love.graphics.printf("Press the key or joystick input for " .. configurable_inputs[self.input_state] .. ", press tab to skip or" .. (config.input and " escape to cancel." or ""), 2, 622, 1280, "center")
		love.graphics.printf("The function keys (F1, F2, etc.), escape and tab keys can't be changed.", 2, 662, 1280, "center")
	end

	love.graphics.setFont(font_New_Big)
	love.graphics.printf("Input Config", 362, 42, 560, "center")


	-- time for the main text!
	love.graphics.setFont(font_New)
	love.graphics.setColor(1, 1, 1, 1)
	for i, input in ipairs(configurable_inputs_readable) do
		love.graphics.printf(input, 242, 72 + i * 40, 600, "left")
	end

	for i, input in ipairs(configurable_inputs) do
		if self.set_inputs[input] then
			love.graphics.printf(self.set_inputs[input], 642, 72 + i * 40, 400, "right")
		end
	end

	if self.input_state > table.getn(configurable_inputs) then
		love.graphics.printf("Inputs OK? Press return to confirm, delete/backspace to retry " .. (config.input and "or escape to cancel." or ""), 0, 620, 1280, "center")
	else
		love.graphics.printf("Press the key or joystick input for " .. configurable_inputs[self.input_state] .. ", press tab to skip or" .. (config.input and " escape to cancel." or ""), 0, 620, 1280, "center")
		love.graphics.printf("The function keys (F1, F2, etc.), escape and tab keys can't be changed.", 0, 660, 1280, "center")
	end

	love.graphics.setFont(font_New_Big)
	love.graphics.printf("Input Config", 360, 40, 560, "center")

	self.axis_timer = self.axis_timer + 1


end

local function addJoystick(input, name)
	if not input.joysticks then
		input.joysticks = {}
	end
	if not input.joysticks[name] then
		input.joysticks[name] = {}
	end
end

function ConfigScene:onInputPress(e)
	if e.type == "key" then
		-- function keys, escape, and tab are reserved and can't be remapped
		if e.scancode == "escape" and config.input then
			-- cancel only if there was an input config already
			playSE("menu_back")
			scene = SettingsScene()
		elseif self.input_state > table.getn(configurable_inputs) then
			if e.scancode == "return" then
				-- save new input, then load next scene
				config.input = self.new_input
				saveConfig()
				playSE("mode_decide")
				scene = TitleScene()
			elseif e.scancode == "delete" or e.scancode == "backspace" then
				-- retry
				self.input_state = 1
				self.set_inputs = newSetInputs()
				self.new_input = {}
				playSE("danger")
			end
		elseif e.scancode == "tab" then
			self.set_inputs[configurable_inputs[self.input_state]] = "skipped"
			self.input_state = self.input_state + 1
			playSE("garbage")
		elseif e.scancode ~= "escape" then
			-- all other keys can be configured
			if not self.new_input.keys then
				self.new_input.keys = {}
			end
			self.set_inputs[configurable_inputs[self.input_state]] = "key " .. love.keyboard.getKeyFromScancode(e.scancode) .. " (" .. e.scancode .. ")"
			self.new_input.keys[e.scancode] = configurable_inputs[self.input_state]
			self.input_state = self.input_state + 1
			playSE("lock")
		end
	elseif string.sub(e.type, 1, 3) == "joy" then
		if self.input_state <= table.getn(configurable_inputs) then
			if e.type == "joybutton" then
				addJoystick(self.new_input, e.name)
				if not self.new_input.joysticks[e.name].buttons then
					self.new_input.joysticks[e.name].buttons = {}
				end
				self.set_inputs[configurable_inputs[self.input_state]] =
					"jbtn " ..
					e.button ..
					" " .. string.sub(e.name, 1, 10) .. (string.len(e.name) > 10 and "..." or "")
				self.new_input.joysticks[e.name].buttons[e.button] = configurable_inputs[self.input_state]
				self.input_state = self.input_state + 1
			elseif e.type == "joyaxis" then
				if (e.axis ~= self.last_axis or self.axis_timer > 30) and math.abs(e.value) >= 1 then
					addJoystick(self.new_input, e.name)
					if not self.new_input.joysticks[e.name].axes then
						self.new_input.joysticks[e.name].axes = {}
					end
					if not self.new_input.joysticks[e.name].axes[e.axis] then
						self.new_input.joysticks[e.name].axes[e.axis] = {}
					end
					self.set_inputs[configurable_inputs[self.input_state]] =
						"jaxis " ..
						(e.value >= 1 and "+" or "-") .. e.axis ..
						" " .. string.sub(e.name, 1, 10) .. (string.len(e.name) > 10 and "..." or "")
					self.new_input.joysticks[e.name].axes[e.axis][e.value >= 1 and "positive" or "negative"] = configurable_inputs[self.input_state]
					self.input_state = self.input_state + 1
					self.last_axis = e.axis
					self.axis_timer = 0
				end
			elseif e.type == "joyhat" then
				if e.direction ~= "c" then
					addJoystick(self.new_input, e.name)
					if not self.new_input.joysticks[e.name].hats then
						self.new_input.joysticks[e.name].hats = {}
					end
					if not self.new_input.joysticks[e.name].hats[e.hat] then
						self.new_input.joysticks[e.name].hats[e.hat] = {}
					end
					self.set_inputs[configurable_inputs[self.input_state]] =
						"jhat " ..
						e.hat .. " " .. e.direction ..
						" " .. string.sub(e.name, 1, 10) .. (string.len(e.name) > 10 and "..." or "")
					self.new_input.joysticks[e.name].hats[e.hat][e.direction] = configurable_inputs[self.input_state]
					self.input_state = self.input_state + 1
				end
			end
		end
	end
end

return ConfigScene
