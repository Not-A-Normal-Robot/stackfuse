local DifficultyScene = Scene:extend()

DifficultyScene.title = "Game Start"

local menu_screens = {
    ModeSelectScene,
    HyperModeSelectScene,
}

function DifficultyScene:new()
    self.menu_state = 1
    DiscordRPC:update({
        details = "In menus",
        state = "Selecting difficulty",
    })
end

function DifficultyScene:update() end

function DifficultyScene:render()
    love.graphics.setColor(1, 1, 1, 1)
    if self.menu_state == 2 then
        love.graphics.draw(
        backgrounds["input_config"],
		0, 0, 0,
		1, 1
    )
    else
    love.graphics.draw(
        backgrounds["game_config"],
		0, 0, 0,
		1, 1
    )
    end

    love.graphics.setFont(font_New_Big)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf("Difficulty Select", 362, 42, 560, "center")

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Difficulty Select", 360, 40, 560, "center")


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

function DifficultyScene:changeOption(rel)
	local len = table.getn(menu_screens)
	self.menu_state = (self.menu_state + len + rel - 1) % len + 1
    print(self.menu_state)
end

function DifficultyScene:onInputPress(e)
	if e.input == "rotate_left" or e.scancode == "return" then
		playSE("ihs")
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

return DifficultyScene
