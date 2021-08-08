local SettingsScene = Scene:extend()

SettingsScene.title = "Settings"

local menu_screens = {
    InputConfigScene,
    GameConfigScene
}

function SettingsScene:new()
    self.menu_state = 1
    DiscordRPC:update({
        details = "In menus",
        state = "Changing settings",
    })
end

function SettingsScene:update() end

function SettingsScene:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
		backgrounds["game_config"],
		0, 0, 0,
		1, 1
    )

    love.graphics.setFont(font_New_Big)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf("Settings", 362, 42, 560, "center")

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Settings", 360, 40, 560, "center")


    love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.rectangle("fill", 440, 278 + 80 * self.menu_state, 400, 70)

    --first we draw the text shadow...
	love.graphics.setColor(0, 0, 0, 0.5)
	for i, screen in pairs(menu_screens) do
		love.graphics.printf(screen.title, 362, 282 + 80 * i, 560, "center")
	end
    --and then the main text.
	love.graphics.setColor(1, 1, 1, 1)
	for i, screen in pairs(menu_screens) do
		love.graphics.printf(screen.title, 360, 280 + 80 * i, 560, "center")
	end
end

function SettingsScene:changeOption(rel)
	local len = table.getn(menu_screens)
	self.menu_state = (self.menu_state + len + rel - 1) % len + 1
end

function SettingsScene:onInputPress(e)
	if e.input == "rotate_left" or e.scancode == "return" then
		playSE("main_decide")
		scene = menu_screens[self.menu_state]()
	elseif e.input == "up" or e.scancode == "up" then
		self:changeOption(-1)
		playSE("cursor")
	elseif e.input == "down" or e.scancode == "down" then
		self:changeOption(1)
		playSE("cursor")
	elseif e.input == "rotate_right" or e.scancode == "backspace" or e.scancode == "delete" or e.scancode == "escape" then
        playSE("menu_back")
		scene = TitleScene()
	end
end

return SettingsScene
