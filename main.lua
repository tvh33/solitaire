require "Column"
require "Slot"
require "GameDeck"
require "Group"
require "Deck"
require "consts"

function love.load()
	math.randomseed(os.time())
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
end

function love.keypressed(key)
	if key == " " then
		for j=0,0 do
			for i=0,game[j].count-1 do
				local tmp = FACE_DOWN
				if game[j].columns[i].count > 3 then tmp = FACE_UP end
				game[j].columns[i]:add_card(deck:get_card(), tmp)
			end
		end
	elseif key == "f" then
		love.graphics.toggleFullscreen()
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
