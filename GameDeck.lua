GameDeck = {}
GameDeck.__index = GameDeck

local FULL = 0
local EMPTY = 1

function GameDeck:new(ix, iy, ix2, iy2)
	local self = {
		x = ix,
		y = iy,
		count = 0,
		cards = {},
		state = FULL,
		stack = Slot:new(ix2, iy2, -1)
	}
	setmetatable(self, GameDeck)
	self:init()
	return self
end

function GameDeck:init()
	local tmp = deck:get_card()
	while tmp ~= -1 do
		self.count = self.count + 1
		self.cards[self.count] = tmp
		tmp = deck:get_card()
	end
end

function GameDeck:draw()
	love.graphics.drawq(SPRITE, BASE[0], self.x-SCALE, self.y-SCALE, 0, SCALE, SCALE, 0, 0, 0, 0)
	if self.state == FULL then
		love.graphics.drawq(SPRITE, CARD_BACK, self.x, self.y, 0, SCALE, SCALE, 0, 0, 0, 0)
	end
	self.stack:draw()
end

function GameDeck:mouse_pressed(ix, iy)
	if ix >= self.x and ix <= self.stack.x+WIDTH
	and iy >= self.y and iy <= self.y+HEIGHT then
		if ix >= self.x and ix <= self.x+WIDTH
		and iy >= self.y and iy <= self.y+HEIGHT then	
			self:deck_clicked()
		else
			self.stack:mouse_pressed(ix, iy)
		end
	end
end

function GameDeck:deck_clicked()
	if self.count > 0 then
		local tmp = 3
		if self.count < 3 then
			tmp = self.count
		end
		for i=0,tmp-1 do
			self.stack:add_card(self.cards[self.count-i])
		end
		self.count = self.count - tmp
		if self.count == 0 then
			self.state = EMPTY
		end
	elseif self.count == 0 then
		if self.stack.count > 0 then
			-- transfer from stack to deck
			for i=1, self.stack.count do
				self.cards[self.stack.count-i+1] = self.stack.cards[i]
			end
			self.count = self.stack.count
			self.stack:remove_card(self.stack.count)
			self.state = FULL
		end
	end
end
