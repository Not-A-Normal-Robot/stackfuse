local KeyConfigScene = Scene:extend()

KeyConfigScene.title = "Key Config"

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

local inputs = {}

local function newSetInputs()
	local set_inputs = {}
	for i, input in ipairs(configurable_inputs) do
		set_inputs[input] = false
	end
	return set_inputs
end

function KeyConfigScene:new()
	self.input_state = 1
	self.set_inputs = newSetInputs()
	self.new_input = {}

	DiscordRPC:update({
		details = "In menus",
		state = "Changing key config",
	})

	inputs = {}
	brerb = ""
end

function KeyConfigScene:update()
end

function KeyConfigScene:render()
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
		love.graphics.printf("Press the key for " .. configurable_inputs[self.input_state] .. ", press tab to skip or" .. (config.input and " escape to cancel." or ""), 2, 622, 1280, "center")
		love.graphics.printf("The function keys (F1, F2, etc.), escape and tab keys can't be changed.", 2, 662, 1280, "center")
	end

	love.graphics.setFont(font_New_Big)
	love.graphics.printf("Key Config", 362, 42, 560, "center")


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
		love.graphics.printf("Press the key for " .. configurable_inputs[self.input_state] .. ", press tab to skip or" .. (config.input and " escape to cancel." or ""), 0, 620, 1280, "center")
		love.graphics.printf("The function keys (F1, F2, etc.), escape and tab keys can't be changed.", 0, 660, 1280, "center")
	end

	love.graphics.setFont(font_New_Big)
	love.graphics.printf("Key Config", 360, 40, 560, "center")

	--secret text! don't breathe this
	love.graphics.setFont(font_New)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.printf(brerb, 0, 0, 1280, "left")
end

function KeyConfigScene:onInputPress(e)

	local a = {
		"c",
		"a",
		"r",
		"n",
		"e",
		"l",
		"i",
		"a",
		"n",
	}

	table.insert(inputs, love.keyboard.getKeyFromScancode(e.scancode))

	local correct = true
	for i=1,#a do
    	if inputs[i] ~= a[i] then
        	correct = false
        	break
    	end
	end



	if e.type == "key" then
		-- function keys, escape, and tab are reserved and can't be remapped
		if e.scancode == "escape" then
			playSE("menu_back")
			scene = InputConfigScene()
		elseif self.input_state > table.getn(configurable_inputs) then
			if e.scancode == "return" then
				-- save new input, then load next scene
				local had_config = config.input ~= nil
                if not config.input then config.input = {} end
                config.input.keys = self.new_input
				saveConfig()
				playSE("mode_decide")
				scene = had_config and InputConfigScene() or TitleScene()
			elseif e.scancode == "delete" or e.scancode == "backspace" then
				-- retry
				self.input_state = 1
				self.set_inputs = newSetInputs()
				self.new_input = {}
				playSE("danger")
			end
		--and we do it again so we can delete inputs at ALL times
		elseif e.scancode == "delete" or e.scancode == "backspace" then
			-- retry
			self.input_state = 1
			self.set_inputs = newSetInputs()
			self.new_input = {}
			playSE("danger")
		elseif e.scancode == "tab" then
			self.set_inputs[configurable_inputs[self.input_state]] = "skipped"
			self.input_state = self.input_state + 1
			playSE("garbage")
		elseif e.scancode ~= "escape" and not self.new_input[e.scancode] then
			-- all other keys can be configured
			self.set_inputs[configurable_inputs[self.input_state]] = "key " .. love.keyboard.getKeyFromScancode(e.scancode) .. " (" .. e.scancode .. ")"
			self.new_input[e.scancode] = configurable_inputs[self.input_state]
            self.input_state = self.input_state + 1
			playSE("lock")
		end
	end
	if correct then
		if not config.gamesettings.hyper then
			self.input_state = 1
			self.set_inputs = newSetInputs()
			self.new_input = {}
			inputs = {}
			playSE("singlecaution")
			config.gamesettings.hyper = true
			brerb = "Hyper modes enabled. Good luck!"
			saveConfig()
		elseif config.gamesettings.hyper then
			self.input_state = 1
			self.set_inputs = newSetInputs()
			self.new_input = {}
			inputs = {}
			playSE("danger")
			config.gamesettings.hyper = false
			brerb = "Hyper modes disabled. git gud"
			saveConfig()
		end
	end
end

return KeyConfigScene
