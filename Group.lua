Group = {}
Group.__index = Group

-- x, y, height, count, gap, mode
function Group:new(ix, iy, ih, ic, ig, mode)
	local self = {
		x = ix,
		y = iy,
		width = (ic*WIDTH+ic*ig),
		height = ih,
		gap = ig,
		count = ic,
		columns = {}
	}
	setmetatable(self, Group)
	self:init(mode)
	return self
end

function Group:init(mode)
	if mode == COLUMN then
		self:init_columns()
	elseif mode == SLOT then
		self:init_slots()
	end
end

function Group:init_columns()
	local oblx = self.x
	for i=0, self.count-1 do
		self.columns[i] = Column:new(oblx + i*WIDTH+i*self.gap, self.y, i%4)
		for j=1, i do
			self.columns[i]:add_card(deck:get_card(), FACE_DOWN)
		end
		self.columns[i]:add_card(deck:get_card(), FACE_UP)
	end
end

function Group:init_slots()
	local oblx = self.x
	for i=0, self.count-1 do
		self.columns[i] = Slot:new(oblx + i*WIDTH+i*self.gap, self.y, i%4)
	end
end

function Group:draw()
	--love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	for i=0,self.count-1 do
		if Selected ~= self.columns[i] then
			self.columns[i]:draw()
		end
	end
end

function Group:mouse_pressed(ix, iy)
	if ix > self.x and ix < self.x + self.width
	and iy >= self.y and iy <= self.y + self.height then
		local scale = math.floor(self.width/self.count)
		local index = math.floor((ix - self.x)/scale)
		if index < self.count and index >= 0 then
			self.columns[index]:mouse_pressed(ix, iy)
		end
	end
end

function Group:find_target(ix, iy)
	if ix >= self.x and ix <= self.x+self.width
	and iy >= self.y and iy <= self.y+self.height then
		local scale = math.floor(self.width/self.count)
		local index = math.floor((ix - self.x)/scale)
		return self.columns[index]
	end
	return -1
end
