local ConfigScene = Scene:extend()

ConfigScene.title = "Input Config"

local menu_screens = {
    KeyConfigScene,
    StickConfigScene
}

function ConfigScene:new()
    self.menu_state = 1
    DiscordRPC:update({
        details = "In menus",
        state = "Changing input config",
    })
end

function ConfigScene:update() end

function ConfigScene:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
		backgrounds["input_config"],
		0, 0, 0,
		1, 1
    )

    love.graphics.setFont(font_New_Big)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf("Input Config", 362, 42, 560, "center")
    love.graphics.setFont(font_New)
    love.graphics.printf("Which controls do you want to configure?", 362, 122, 560, "center")

    love.graphics.setFont(font_New_Big)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Input Config", 360, 40, 560, "center")
    love.graphics.setFont(font_New)
    love.graphics.printf("Which controls do you want to configure?", 360, 120, 560, "center")

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", 410, 278 + 80 * self.menu_state, 460, 70)

    love.graphics.setFont(font_New_Big)
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

function ConfigScene:changeOption(rel)
	local len = table.getn(menu_screens)
	self.menu_state = (self.menu_state + len + rel - 1) % len + 1
end

function ConfigScene:onInputPress(e)
	if e.input == "rotate_left" or e.scancode == "return" then
		playSE("ihs")
		scene = menu_screens[self.menu_state]()
	elseif e.input == "up" or e.scancode == "up" then
		self:changeOption(-1)
		playSE("cursor")
	elseif e.input == "down" or e.scancode == "down" then
		self:changeOption(1)
		playSE("cursor")
	elseif config.input and (
		e.input == "rotate_right" or e.scancode == "backspace" or e.scancode == "delete" or e.scancode == "escape"
	) then
        playSE("menu_back")
		scene = SettingsScene()
	end
end

return ConfigScene
