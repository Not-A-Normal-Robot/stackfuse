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

--[[ CUSTOM FONTS ]]

font_newBigFont = love.graphics.newImageFont(
	"res/fonts/newBigFont.png",
	"0123456789:."
)

font_newBigFont:setFilter("nearest", "nearest")

font_newBiggerFont = love.graphics.newImageFont(
	"res/fonts/newBiggerFont.png",
	"0123456789:."
)

font_newBiggerFont:setFilter("nearest", "nearest")

font_NEC = love.graphics.newImageFont(
	"res/fonts/newMainFont.png",
	" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_" ..
	"`abcdefghijklmnopqrstuvwxyz{|}~™"
)

font_NEC:setFilter("nearest", "nearest")

font_NEC_Big = love.graphics.newImageFont(
	"res/fonts/newMainFontBig.png",
	" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_" ..
	"`abcdefghijklmnopqrstuvwxyz{|}~™"
)

font_NEC_Big:setFilter("nearest", "nearest")
