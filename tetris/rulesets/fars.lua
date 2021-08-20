local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local FARS = Ruleset:extend()

FARS.name = "Flexible ARS"
FARS.hash = "FARS"

FARS.softdrop_lock = false
FARS.harddrop_lock = true
FARS.are_cancel = false



FARS.spawn_positions = {
	I = { x=5, y=4 },
	S = { x=4, y=5 },
	Z = { x=4, y=5 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	T = { x=4, y=5 },
}

FARS.big_spawn_positions = {
	I = { x=3, y=2 },
	S = { x=2, y=3 },
	Z = { x=2, y=3 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	T = { x=2, y=3 },
}

FARS.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
	},
	J={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=-1} },
		{ {x=0, y=-1}, {x=1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
	},
	L={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=1, y=-1} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=0}, {x=0, y=0} },
	},
	O={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
	},
	S={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=-2}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=-2}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
	},
	T={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=-1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-1}, {x=0, y=-2} },
	},
	Z={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
	}
}


-- clockwise kicks: {{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}},
-- counterclockwise kicks: {{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},

FARS.wallkicks_3x3 = {
	[0]={
		[1]={{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}},
		[2]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
		[3]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
	},
	[1]={
		[0]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
		[2]={{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}},
		[3]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
	},
	[2]={
		[0]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
		[1]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
		[3]={{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}},
	},
	[3]={
		[0]={{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}},
		[1]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
		[2]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
	},
};

FARS.wallkicks_line = {
	[0]={
		[1]={{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}},
		[2]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
		[3]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
	},
	[1]={
		[0]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
		[2]={{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}},
		[3]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
	},
	[2]={
		[0]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
		[1]={{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}},
		[3]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
	},
	[3]={
		[0]={{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}},
		[1]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
		[2]={{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}},
	},
};

function FARS:attemptWallkicks(piece, new_piece, rot_dir, grid)

	local kicks
	if piece.shape == "O" then
		return
	else
		kicks = FARS.wallkicks_3x3[piece.rotation][new_piece.rotation]
	end

	assert(piece.rotation ~= new_piece.rotation)

	for idx, offset in pairs(kicks) do
		kicked_piece = new_piece:withOffset(offset)
		if grid:canPlacePiece(kicked_piece) then
			piece:setRelativeRotation(rot_dir)
			piece:setOffset(offset)
			self:onPieceRotate(piece, grid)
			return
		end
	end

	if piece.shape == "I" then
		if piece:isDropBlocked(grid) and (new_piece.rotation == 1 or new_piece.rotation == 3) and not piece.floorkicks then
			if grid:canPlacePiece(new_piece:withOffset({x=0, y=-1})) then
				self:onPieceRotate(piece, grid)
				piece:setRelativeRotation(rot_dir):setOffset({x=0, y=-1})
				piece.floorkicks = true
			elseif grid:canPlacePiece(new_piece:withOffset({x=0, y=-2})) then
				self:onPieceRotate(piece, grid)
				piece:setRelativeRotation(rot_dir):setOffset({x=0, y=-2})
				piece.floorkicks = true
			end
		end
	end

	if piece.shape == "T"
		   and new_piece.rotation == 2
		   and not piece.floorkicks
		   and piece:isDropBlocked(grid)
		   and grid:canPlacePiece(new_piece:withOffset({x=0, y=-1}))
		   then
			-- T floorkick
			piece.floorkicks = true
			self:onPieceRotate(piece, grid)
			piece:setRelativeRotation(rot_dir):setOffset({x=0, y=-1})
	end
end

function FARS:onPieceCreate(piece)
	piece.floorkicks = false
end

function FARS:onPieceDrop(piece, grid)
	piece.lock_delay = 0 -- step reset
end

function FARS:getDefaultOrientation() return 1 end

return FARS
