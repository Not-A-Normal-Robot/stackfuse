--fallback fonts
font_3x5 = love.graphics.newImageFont(
	"res/fonts/3x5.png",
	" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_" ..
	"`abcdefghijklmnopqrstuvwxyz{|}~™",
	-1
)

font_3x5_2 = love.graphics.newImageFont(
	"res/fonts/3x5_double.png",
	" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_" ..
	"`abcdefghijklmnopqrstuvwxyz{|}~™",
	-2
)

font_3x5_3 = love.graphics.newImageFont(
	"res/fonts/3x5_medium.png",
	" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_" ..
	"`abcdefghijklmnopqrstuvwxyz{|}~",
	-3
)

font_3x5_4 = love.graphics.newImageFont(
	"res/fonts/3x5_large.png",
	" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_" ..
	"`abcdefghijklmnopqrstuvwxyz{|}~",
	-4
)

font_8x11 = love.graphics.newImageFont(
	"res/fonts/8x11_medium.png",
	"0123456789:.",
	1
)

--the good shit
font_New = love.graphics.newFont("res/fonts/JetBrainsMono-Regular.ttf", 24)
font_New_Big = love.graphics.newFont("res/fonts/JetBrainsMono-Regular.ttf", 48)
