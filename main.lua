require "Column"
require "Slot"
require "GameDeck"
require "Group"
require "Deck"
require "consts"

local PLAYING = 0
local WON = 1
local game_state = PLAYING

function love.load()
	math.randomseed(os.time())
	math.random()
	math.random()
	Selected = -1
	deck = Deck:new(52)
	game = {}
	game[0] = Group:new(GAP, HEIGHT+3*GAP, 450, 7, GAP, COLUMN)
	game[1] = Group:new(GAP+3*WIDTH+3*GAP, GAP, HEIGHT, 4, GAP, SLOT)
	game[2] = GameDeck:new(GAP, GAP, WIDTH+2*GAP, GAP)
end

function love.update(dt)
	if Selected ~= -1 then
		Selected:update(dt)
	end
end

function love.draw()
	for i=0,2 do
		game[i]:draw()
	end
	if Selected ~= -1 then
		Selected:draw()
	end
	if game_state == WON then
		love.graphics.print("YOU WON", 0, 0)
	end
end

function love.keypressed(key)
	if key == "f" then
		love.graphics.toggleFullscreen()
	elseif key == "r" then
		deck:restart()
		for i=0,2 do
			game[i]:restart()
		end
	end
end

function love.mousepressed(x, y, button)
	if button == "l" then
		game[0]:mouse_pressed(x, y)
		game[1]:mouse_pressed(x, y)
		game[2]:mouse_pressed(x, y)
	end
end

function love.mousereleased(x, y, button)
	if button == "l" then
		if Selected ~= -1 then
			Selected:mouse_released(x, y)
		end
	end
end

function find_target(ix, iy)	
	for i=0,1 do
		res =  game[i]:find_target(ix, iy)
		if res ~= -1 then
			return res
		end
	end
	return -1
end

function check_win()
	for i=0,3 do
		if game[1].columns[i].count < 13 then
			return false
		end
	end
	return true
end