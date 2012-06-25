require "consts"

Column = {}
Column.__index = Column

function Column:new(ix, iy, iid)
	local self = {
		x = ix,
		y = iy,
		id = iid,
		count = 0,
		offset = 20,
		cards = {}, 
		dragging = {active = false, xdif = 0, ydif = 0, index = 0, dx = 0, dy = 0}
	}
	setmetatable(self, Column)
	return self
end

function Column:draw()
	local ii
	love.graphics.rectangle("line", self.x, self.y, WIDTH, HEIGHT)
	for ii=0,self.count do
		if self.count > 0 and ii > 0 then
			if self.dragging.active == true and ii >= self.dragging.index then
				love.graphics.draw(SPRITE, self.dragging.dx, self.dragging.dy+(ii-self.dragging.index)*self.offset, 0, 1, 1, 0, 0, 0, 0)
				love.graphics.print(id_to_string(self.cards[ii]), self.dragging.dx+WIDTH+20, self.dragging.dy+(ii-self.dragging.index+1)*self.offset)				
			else
				love.graphics.draw(SPRITE, self.x, self.y+(ii-1)*self.offset, 0, 1, 1, 0, 0, 0, 0)
				love.graphics.print(id_to_string(self.cards[ii]), self.x+WIDTH+20, self.y+ii*self.offset)
			end
		end
	end
end

function Column:add_card(id)
	if id == -1 then
		return
	end
	self.count = self.count + 1
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
	if ix >= self.x and ix <= self.x+WIDTH then
		if iy >= self.y and iy <= self.y+HEIGHT+(self.count-1)*self.offset then
			local tmp = math.floor((iy - self.y)/self.offset) + 1
			self.dragging.active = true
			if tmp > self.count then
				tmp = self.count
			end	
			self.dragging.index = tmp
			self.dragging.xdif = ix - self.x
			self.dragging.ydif = (iy - self.y)-(tmp-1)*self.offset
			self.dragging.dx = self.x
			self.dragging.dy = self.y + tmp * self.offset
		end
	end
end

function Column:mouse_released(ix, iy)
	if self.dragging.active == true then
		self.dragging.active = false
	end
end
