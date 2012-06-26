Slot = {}
Slot.__index = Slot

function Slot:new(ix, iy, ia)
	local self = {
		x = ix,
		y = iy,
		count = 0,
		cards = {},
		accept = ia,
		dragging = {active = false, xdif = 0, ydif = 0, dx = 0, dy = 0}
	}
	setmetatable(self, Slot)
	return self
end

function Slot:draw()
	love.graphics.drawq(SPRITE, BASE[self.accept+1], self.x-SCALE, self.y-SCALE, 0, SCALE, SCALE, 0, 0, 0, 0)
	if self.count > 0 then
		local h = get_house(self.cards[self.count])
		local v = get_value(self.cards[self.count])
		if self.dragging.active == true then
			if self.count > 1 then
				local h2 = get_house(self.cards[self.count-1])
				local v2 = get_value(self.cards[self.count-1])
				love.graphics.drawq(SPRITE, SPRITE_SHEET[h2][v2], self.x, self.y, 0, SCALE, SCALE, 0, 0, 0, 0)
			end
			love.graphics.drawq(SPRITE, SPRITE_SHEET[h][v], self.dragging.dx, self.dragging.dy, 0, SCALE, SCALE, 0, 0, 0, 0)
		else
			love.graphics.drawq(SPRITE, SPRITE_SHEET[h][v], self.x, self.y, 0, SCALE, SCALE, 0, 0, 0, 0)
		end
	end
	
end

function Slot:add_card(id, mode)
	self.count = self.count + 1
	self.cards[self.count] = id
end

function Slot:remove_card(amount)
	self.count = self.count - amount
end

function Slot:update(dt)
	if self.dragging.active == true then
		self.dragging.dx = love.mouse.getX() - self.dragging.xdif
		self.dragging.dy = love.mouse.getY() - self.dragging.ydif
	end
end

function Slot:mouse_pressed(ix, iy)
	if self:check_collision(ix, iy, TOP) then
		self.dragging.active = true
		self.dragging.xdif = ix - self.x
		self.dragging.ydif = iy - self.y
		self.dragging.dx = self.x
		self.dragging.dy = self.y
		-- make global reference
		Selected = self
	end
end

function Slot:check_collision(ix, iy, mode)
	if ix >= self.x and ix <= self.x + WIDTH
	and iy >= self.y and iy <= self.y + HEIGHT then
		return true
	end
	return false
end

function Slot:mouse_released(ix, iy)
	self.dragging.active = false
	local target = find_target(ix, iy)
	if target == Selected or target == -1 then
		Selected = -1
		return		
	end
	Selected = -1	
	if target:receive(ix, iy, 1, self.cards[self.count]) then
		target:add_card(self.cards[self.count], FACE_UP)
		self:remove_card(1)
	end
end

function Slot:receive(ix, iy, amount, id)
	if self:check_collision(ix, iy, TOP) and amount == 1 and self.accept == get_house(id) then
		if get_value(id) == self.count or self.accept == -1 then
			return true
		end
	end
	return false
end
