SCALE = 5

WIDTH = 18*SCALE
HEIGHT = 24*SCALE
GAP = 5*SCALE

SPADES = 0
HEARTS = 1
CLUBS = 2
DIAMONDS = 3

-- collision checking modes
FULL = 0
TOP = 1
-- group modes
DECK = 0
SLOT = 1
COLUMN = 2
--card states
FACE_UP = 0
FACE_DOWN = 1

SPRITE = love.graphics.newImage("sprite_sheet.png")
SPRITE:setFilter("nearest", "nearest")
SPRITE_SHEET = {}
for i=0,3 do
	SPRITE_SHEET[i] = {}
	for j=0,12 do
		SPRITE_SHEET[i][j] = love.graphics.newQuad(j*18, i*24, 18, 24, 256, 128)
	end
end
CARD_BACK = love.graphics.newQuad(0, 4*24, 18, 24, 256, 128)
BASE = {}
for i=0,4 do
	BASE[i] = love.graphics.newQuad(18+i*20, 4*24, 20, 26, 256, 128)
end
