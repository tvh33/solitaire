require "Column"
require "Group"
require "Deck"
require "consts"

function love.load()
	Selected = -1
	deck = Deck:new(52)
	group = Group:new(20, 20, 700, 500, 4)
end

function love.update(dt)
	if Selected ~= -1 then
		Selected:update(dt)
	end
end

function love.draw()
	group:draw()
end

function love.keypressed(key)
	if key == " " then
		for i=0,group.count-1 do
			group.columns[i]:add_card(deck:get_card())
		end
	end
end

function love.mousepressed(x, y, button)
	if button == "l" then
		group:mouse_pressed(x, y)
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
	return group:find_target(ix, iy)
end
