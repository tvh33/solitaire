Deck = {}
Deck.__index = Deck

function Deck:new(amount)
	local self = {
		array = {},
		max = amount-1,
		cards_left = amount-1
	}
	setmetatable(self, Deck)
	self:init()
	return self
end

function Deck:init()
	for i=0,51 do
		self.array[i] = i
	end
end

function Deck:restart()
	self.cards_left = self.max
end

function Deck:get_card()
	if self.cards_left >= 0 then
		local index = math.random(self.cards_left+1)-1
		local res = self.array[index]	
		self.array[index] = self.array[self.cards_left]
		self.array[self.cards_left] = res
		self.cards_left = self.cards_left - 1
		return res
	end
	return -1
end

function id_to_string(id)
	if id == -1 then
		return "no card"
	end
	if id >= 100 then
		id = id - 100
	end
	local house = get_house(id)
	local value = get_value(id)
	local res = (value+1).." of "
	if house == SPADES then res = res.."spades"
	elseif house == HEARTS then res = res.."hearts"
	elseif house == CLUBS then res = res.."clubs"
	else res = res.."diamonds" end
	return res 
end

function get_house(id)
	if id == -1 then
		return "no card"
	end
	if id >= 100 then
		id = id - 100
	end
	return math.floor(id/13)
end

function get_value(id)
	if id == -1 then
		return "no card"
	end
	if id >= 100 then
		id = id - 100
	end
	return (id%13)
end