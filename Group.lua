require "consts"

Group = {}
Group.__index = Group

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
		if Selected ~= self.columns[i] then
			self.columns[i]:draw()
		end
	end
	if Selected ~= -1 then
		Selected:draw()
	end
end

function Group:mouse_pressed(ix, iy)
	if ix > self.x and ix < self.x + self.width
	and iy >= self.y and iy <= self.y + self.height then
		local scale = math.floor(self.width/self.count)
		local index = math.floor((ix - self.x)/scale)
		self.columns[index]:mouse_pressed(ix, iy)		
	end
end

function Group:find_target(ix, iy)
	local scale = math.floor(self.width/self.count)
	local index = math.floor((ix - self.x)/scale)
	return self.columns[index]
end
