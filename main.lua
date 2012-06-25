require "Column"
require "Group"
require "consts"

function love.load()
	column_array = {}
	deck = {}
	cards_left = 52

	for i=1,52 do
		deck[i] = i
	end

	group = Group:new(20, 20, 700, 300, 7)
	group2 = Group:new(20, 340, 500, 200, 4)
end

function love.update(dt)
	group:update(dt)
end

function love.draw()
	group:draw()
	group2:draw()
end

function love.keypressed(key)
	if key == " " then
		for i=0,group.count-1 do
			--column_array[i]:add_card(get_card())
			group.columns[i]:add_card(get_card())
		end
	elseif key == "r" then
		for i=0,group.count-1 do
			--column_array[i]:remove_card()
			group.columns[i]:remove_card(1)
		end
	end
end

function get_card()
	if cards_left >= 1 then
		local index = math.random(cards_left)
		local res = deck[index]	
		--swap [cards_left] and [index]
		deck[index] = deck[cards_left]
		deck[cards_left] = res
		cards_left = cards_left - 1
		return res
	end
	return -1
end

function id_to_string(id)
	if id == -1 then
		return "no card"
	end
	local house = math.floor(id/13)
	local value = (id%12)+1
	local res = (value+1).." of "
	if (house == SPADES) then res = res.."spades"
	elseif (house == HEARTS) then res = res.."hearts"
	elseif (house == CLUBS) then res = res.."clubs"
	else res = res.."diamonds" end
	return res 
end

function love.mousepressed(x, y, button)
	if button == "l" then
		group:mouse_pressed(x, y)
	end
end

function love.mousereleased(x, y, button)
	if button == "l" then
		group:mouse_released(x, y)
	end
end
