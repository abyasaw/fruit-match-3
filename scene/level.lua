LevelScene = gideros.class(Sprite)

function LevelScene:init()

	-- add background screen
	local background = Bitmap.new(Texture.new("asset/background/bg_lvlselect.png"))
	background:setAnchorPoint(0.5,0.5)
	background:setPosition(application:getContentWidth()/2,application:getContentHeight()/2)
	self:addChild(background)
	
	local buttons = { 
		{ level = "1", x = 100, y = 280 },
		{ level = "2", x = 160, y = 280 },
		{ level = "3", x = 220, y = 280 },
		{ level = "4", x = 280 , y = 280 },
		{ level = "5", x = 340, y = 280 },
		{ level = "6", x = 100, y = 340 },
		{ level = "7", x = 160, y = 340 },
		{ level = "8", x = 220, y = 340 },
		{ level = "9", x = 280, y = 340 },
		{ level = "10", x = 340, y = 340 }
	}
	
	local button = { }
	for index, prop in next, buttons do
	
		buttonImage = Bitmap.new(Texture.new("asset/images/lvl" .. prop["level"] .. ".png", conf.textureFilter))
		buttonUp = buttonImage
		buttonDown = buttonImage
		buttonDown:setPosition(1,1)
		
		button[index] = Button.new(buttonUp, buttonDown)
		button[index]:setPosition(prop["x"], prop["y"]);
		
		self:addChild(button[index])
	end
	
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, 0xff4411, 1)
	shape:beginPath()
	shape:moveTo(0,0)
	shape:lineTo(50, 0)
	shape:lineTo(50, 30)
	shape:lineTo(0, 30)
	shape:lineTo(0, 0)
	shape:endPath()
	shape:setPosition(100, 400)
	
	shape:addEventListener(Event.MOUSE_DOWN,
		function()
			sceneManager:changeScene("option", 1, conf.transition, conf.easing)
		end
	)
	
	self:addChild(shape)
	
end