Column = {}
Column.__index = Column

function Column:new(ix, iy)
	local self = {
		x = ix,
		y = iy,
		count = 0,
		offset = GAP+GAP/10,
		cards = {}, 
		dragging = {active = false, xdif = 0, ydif = 0, index = 0, dx = 0, dy = 0}
	}
	setmetatable(self, Column)
	return self
end

function Column:draw()
	local ii
	love.graphics.drawq(SPRITE, BASE[0], self.x-SCALE, self.y-SCALE, 0, SCALE, SCALE, 0, 0, 0, 0)
	for ii=0,self.count do
		if self.count > 0 and ii > 0 then
		local h = get_house(self.cards[ii])
		local v = get_value(self.cards[ii])
			if	self.cards[ii] >= 100 then
				love.graphics.drawq(SPRITE, CARD_BACK, self.x, self.y+(ii-1)*self.offset, 0, SCALE, SCALE, 0, 0, 0, 0)
			elseif self.dragging.active == true and ii >= self.dragging.index then
				love.graphics.drawq(SPRITE, SPRITE_SHEET[h][v], self.dragging.dx, self.dragging.dy+(ii-self.dragging.index)*self.offset, 0, SCALE, SCALE, 0, 0, 0, 0)		
			else
				love.graphics.drawq(SPRITE, SPRITE_SHEET[h][v], self.x, self.y+(ii-1)*self.offset, 0, SCALE, SCALE, 0, 0, 0, 0)
			end
		end
	end
end

function Column:add_card(id, mode)
	if id == -1 then
		return
	end
	self.count = self.count + 1
	if mode == FACE_DOWN then
		id = id + 100
	end
	self.cards[self.count] = id
	
end

function Column:remove_card(amount)
	self.count = self.count - amount
end

function Column:update(dt)
	if self.dragging.active == true then
		self.dragging.dx = love.mouse.getX() - self.dragging.xdif
		self.dragging.dy = love.mouse.getY() - self.dragging.ydif
	end
end

function Column:mouse_pressed(ix, iy)
	if self:check_collision(ix, iy, FULL) and self.count > 0 then
		local tmp = self:get_index(ix, iy)
		if self.cards[tmp] >= 100 then
			self:click_on_hidden(tmp)
			return
		end
		self.dragging.active = true
		self.dragging.index = tmp
		self.dragging.xdif = ix - self.x
		self.dragging.ydif = (iy - self.y)-(tmp-1)*self.offset
		self.dragging.dx = self.x
		self.dragging.dy = self.y + tmp * self.offset
		-- make global reference
		Selected = self
	end
end

function Column:click_on_hidden(index)
	if index == self.count then
		self.cards[index] = self.cards[index] - 100
	end
end

function Column:check_collision(ix, iy, mode)
	if ix > self.x and ix < self.x+WIDTH then
		if iy > self.y + mode*((self.count-1)*self.offset) and iy < self.y+HEIGHT+(self.count-1)*self.offset then
			return true
		end
	end
	return false
end

function Column:get_index(ix, iy)
	local tmp = math.floor((iy - self.y)/self.offset) + 1
	if tmp > self.count then
		tmp = self.count
	end
	return tmp
end

function Column:mouse_released(ix, iy)
	self.dragging.active = false
	local target = find_target(ix, iy)
	if target == Selected or target == -1 or target == nill then
		Selected = -1
		return		
	end
	Selected = -1	
	if target:receive(ix, iy, (self.count-self.dragging.index+1), self.cards[self.dragging.index]) then
		if self.cards[self.dragging.index-1] ~= nil and self.cards[self.dragging.index-1] >= 100 then
			self.cards[self.dragging.index-1] = self.cards[self.dragging.index-1] - 100
		end
		j = 0
		for i=self.dragging.index, self.count do
			target:add_card(self.cards[i], FACE_UP)
			j = j + 1
		end
		self:remove_card(j)
	end
end

function Column:receive(ix, iy, amount, id)
	if self:check_collision(ix, iy, TOP) then
		if self:check_rules(id) then
			return true	
		end
	end
	return false
end

function Column:check_rules(id)
	if self.count > 0 then
		local tmp = get_house(self.cards[self.count])%2
		local tmp2 = get_value(self.cards[self.count])
		if get_house(id)%2 ~= tmp and get_value(id) == tmp2-1 then
			return true
		end
	elseif self.count == 0 then
		local tmp = get_value(id)
		if tmp == 12 then
			return true
		end
	end
	return false
end