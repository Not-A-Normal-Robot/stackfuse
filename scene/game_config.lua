local ConfigScene = Scene:extend()

ConfigScene.title = "Game Settings"

require 'load.save'
require 'libs.simple-slider'

ConfigScene.options = {
	-- this serves as reference to what the options' values mean i guess?
	-- Format: {name in config, displayed name, uses slider?, options OR slider name}
	--{"manlock", "Manual Locking", false, {"Per ruleset", "Per gamemode", "Harddrop", "Softdrop"}},
	-- {"piece_colour", "Piece Colours", false, {"Per ruleset", "Arika", "TTC"}},
	{"world_reverse", "A Button Rotation", false, {"Left", "Auto", "Right"}},
	-- {"spawn_positions", "Spawn Positions", false, {"Per ruleset", "In field", "Out of field"}},
	-- {"display_gamemode", "Display Gamemode", false, {"On", "Off"}},
	-- {"das_last_key", "DAS Last Key", false, {"Off", "On"}},
	-- {"smooth_movement", "Smooth Piece Drop", false, {"On", "Off"}},
	-- {"synchroes_allowed", "Synchroes", false, {"Per ruleset", "On", "Off"}},
	{"diagonal_input", "Diagonal Input", false, {"On", "Off"}},
	{"buffer_lock", "Buffer Drop Type", false, {"Off", "Hold", "Tap"}},
	{"sfx_volume", "SFX", true, "sfxSlider"},
	{"bgm_volume", "BGM", true, "bgmSlider"},
}
local optioncount = #ConfigScene.options

function ConfigScene:new()
	-- load current config
	self.config = config.input
	self.highlight = 1

	DiscordRPC:update({
		details = "In menus",
		state = "Changing game settings",
	})

	self.sfxSlider = newSlider(640, 500, 600, config.sfx_volume * 100, 0, 100, function(v) config.sfx_volume = v / 100 end, {width=40, knob="circle", track="roundrect"})
	self.bgmSlider = newSlider(640, 660, 600, config.bgm_volume * 100, 0, 100, function(v) config.bgm_volume = v / 100 end, {width=40, knob="circle", track="roundrect"})
end

function ConfigScene:update()
	self.sfxSlider:update()
	self.bgmSlider:update()
end

function ConfigScene:render()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(
		backgrounds["input_config"],
		0, 0, 0,
		1, 1
	)

	love.graphics.setFont(font_New_Big)
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.printf("Game Settings", 2, 42, 1280, "center")
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf("Game Settings", 0, 40, 1280, "center")

	--Lazy check to see if we're on the SFX or BGM slider. Probably will need to be rewritten if more options get added.
	love.graphics.setColor(1, 1, 1, 0.5)
	if not ConfigScene.options[self.highlight][3] then
		love.graphics.rectangle("fill", 20, 40 + 80 * self.highlight, 1240, 70)
	else
		love.graphics.rectangle("fill", 370, 240 + 160 * (self.highlight - 3), 540, 70)
	end

	love.graphics.setFont(font_New_Big)
	for i, option in ipairs(ConfigScene.options) do
		if not option[3] then
			love.graphics.setColor(0, 0, 0, 0.5)
			love.graphics.printf(option[2], 42, 42 + i * 80, 1280, "left")
			for j, setting in ipairs(option[4]) do
				--love.graphics.setColor(1, 1, 1, config.gamesettings[option[1]] == j and 1 or 0.5)
				--love.graphics.setColor(config.gamesettings[option[1]] == j and 1 or 0.8, config.gamesettings[option[1]] == j and 1 or 0.8, config.gamesettings[option[1]] == j and 1 or 0.8, 0.5)
				love.graphics.printf(setting, 602 + 160 * j, 42 + i * 80, 1280, "left")
			end
		end
	end

	love.graphics.setFont(font_New_Big)
	for i, option in ipairs(ConfigScene.options) do
		if not option[3] then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.printf(option[2], 40, 40 + i * 80, 1280, "left")
			for j, setting in ipairs(option[4]) do
				--love.graphics.setColor(1, 1, 1, config.gamesettings[option[1]] == j and 1 or 0.5)
				love.graphics.setColor(config.gamesettings[option[1]] == j and 1 or 0.8, config.gamesettings[option[1]] == j and 1 or 0.8, config.gamesettings[option[1]] == j and 1 or 0.8, 1)
				love.graphics.printf(setting, 600 + 160 * j, 40 + i * 80, 1280, "left")
			end
		end
	end

	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.setFont(font_New_Big)
	love.graphics.printf("SFX Volume: " .. math.floor(self.sfxSlider:getValue()) .. "%", 2, 402, 1280, "center")
	love.graphics.printf("BGM Volume: " .. math.floor(self.bgmSlider:getValue()) .. "%", 2, 562, 1280, "center")

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf("SFX Volume: " .. math.floor(self.sfxSlider:getValue()) .. "%", 0, 400, 1280, "center")
	love.graphics.printf("BGM Volume: " .. math.floor(self.bgmSlider:getValue()) .. "%", 0, 560, 1280, "center")

	love.graphics.setColor(1, 1, 1, 0.75)
	self.sfxSlider:draw()
	self.bgmSlider:draw()
end

function ConfigScene:onInputPress(e)
	if e.input == "rotate_left" or e.scancode == "return" then
		playSE("mode_decide")
		saveConfig()
		scene = SettingsScene()
	elseif e.input == "up" or e.scancode == "up" then
		playSE("cursor")
		self.highlight = Mod1(self.highlight-1, optioncount)
	elseif e.input == "down" or e.scancode == "down" then
		playSE("cursor")
		self.highlight = Mod1(self.highlight+1, optioncount)
	elseif e.input == "left" or e.scancode == "left" then
		if not self.options[self.highlight][3] then
			playSE("cursor_lr")
			local option = ConfigScene.options[self.highlight]
			config.gamesettings[option[1]] = Mod1(config.gamesettings[option[1]]-1, #option[4])
		else
			local sld = self[self.options[self.highlight][4]]
			sld.value = math.max(sld.min, math.min(sld.max, (sld:getValue() - 5) / (sld.max - sld.min)))
			sld:update()
			playSE("cursor")
		end
	elseif e.input == "right" or e.scancode == "right" then
		if not self.options[self.highlight][3] then
			playSE("cursor_lr")
			local option = ConfigScene.options[self.highlight]
			config.gamesettings[option[1]] = Mod1(config.gamesettings[option[1]]+1, #option[4])
		else
			sld = self[self.options[self.highlight][4]]
			sld.value = math.max(sld.min, math.min(sld.max, (sld:getValue() + 5) / (sld.max - sld.min)))
			sld:update()
			playSE("cursor")
		end
	elseif e.input == "rotate_right" or e.scancode == "delete" or e.scancode == "backspace" or e.scancode == "escape" then
		playSE("menu_back")
		loadSave()
		scene = SettingsScene()
	end
end

return ConfigScene
