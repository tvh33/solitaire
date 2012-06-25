require "consts"

Group = {}
Group.__index = Group

local clicked = 0

function Group:new(ix, iy, iw, ih, ic)
	local self = {
		x = ix,
		y = iy,
		width = iw,
		height = ih,
		count = ic,
		columns = {}
	}
	setmetatable(self, Group)
	self:init()
	return self
end

function Group:init()
	local scale = math.floor(self.width/self.count)
	for i=0, self.count-1 do
		self.columns[i] = Column:new(self.x + i*scale + WIDTH/2, self.y, i)
	end
end

function Group:draw()
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	for i=0,self.count-1 do
		if i ~= clicked then
			self.columns[i]:draw()
		end
	end
	self.columns[clicked]:draw()
end

function Group:update(dt)
	self.columns[clicked]:update(dt)
end

function Group:mouse_pressed(ix, iy)
	if ix > self.x and ix < self.x + self.width
	and iy >= self.y and iy <= self.y + self.height then
		local scale = math.floor(self.width/self.count)
		local index = math.floor((ix - self.x)/scale)
		clicked = index
		self.columns[index]:mouse_pressed(ix, iy)		
	end
end

function Group:mouse_released(ix, iy)
	self.columns[clicked]:mouse_released(ix, iy)
end

function Group:drop_column(ix, iy, iid)
	if ix > self.x and ix < self.x + self.width
	and iy >= self.y and iy <= self.y + self.height then
		local scale = math.floor(self.width/self.count)
		local index = math.floor((ix - self.x)/scale)
		if ix >= self.columns[index].x and ix <= self.columns[index].x+WIDTH
		and iy >= self.columns[index].y + self.columns[index].offset * (self.columns[index].count-1) -- What if empty colum? -1?
		and iy <= self.columns[index].y + self.columns[index].offset * (self.columns[index].count-1) + HEIGHT then
			return index
		end
	end
	return -1
end
