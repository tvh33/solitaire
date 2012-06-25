Deck = {}
Deck.__index = Deck

function Deck:new(amount)
	local self = {
		array = {},
		cards_left = amount
	}
	setmetatable(self, Deck)
	self:init()
	return self
end

function Deck:init()
	for i=1,52 do
		self.array[i] = i
	end
end

function Deck:get_card()
	if self.cards_left >= 1 then
		local index = math.random(self.cards_left)
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
	local house = math.floor(id/13)
	local value = (id%12)+1
	local res = (value+1).." of "
	if (house == SPADES) then res = res.."spades"
	elseif (house == HEARTS) then res = res.."hearts"
	elseif (house == CLUBS) then res = res.."clubs"
	else res = res.."diamonds" end
	return res 
end
