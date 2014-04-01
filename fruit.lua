Fruit = gideros.class(Sprite)

function Fruit:init(type)

	-- fruit list
	local imgFolder = "asset/images/"
	self.fruits = {
		imgFolder .. "watermelon.png",
		imgFolder .. "strawberry.png",
		imgFolder .. "pineapple.png",
		imgFolder .. "grape.png",
		imgFolder .. "banana.png",
		imgFolder .. "apple.png",
		imgFolder .. "papaya.png"
	}
	
	self.fruitType = type
	self.isMarkedToDestroy = false
	self.image = Bitmap.new(Texture.new(self.fruits[type], conf.textureFilter))
	self.image:setAnchorPoint(0.5, 0.5)
	self:addChild(self.image)
	
	self.col = 0
	self.row = 0
	self.initialX = 0
	self.initialY = 0
	self.i, self.j = 0, 0
	
	-- register to all mouse and touch events
	--[[
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
	]]--
end

function Fruit:setIndex(col, row)
	self.col, self.row = col, row
	self.i, self.j = col, row
end

-- get index position
function Fruit:getIndex()
	return self.col, self.row
end

-- set initial position
function Fruit:setInitialPosition(x, y)
	self.initialX, self.initialY = x, y
end

-- get initial x position
function Fruit:getInitialX()
	return self.initialX
end

-- get initial y position
function Fruit:getInitialY()
	return self.initialY
end

-- get initial position
function Fruit:getInitialPosition()
	return self.initialX, self.initialY
end