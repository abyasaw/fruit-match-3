MenuScene = gideros.class(Sprite)

function MenuScene:init()

	-- add background screen
	local background = Bitmap.new(Texture.new("asset/background/mainmenu_background.png", conf.textureFilter))
	background:setAnchorPoint(0.5, 0.5)
	background:setPosition(application:getContentWidth()/2,application:getContentHeight()/2)
	self:addChild(background)
	
	-- menu container
	self.menu = VerticalView.new({ padding = 20, easing = conf.easing })
	self:addChild(self.menu)
	
	-- add play button
	self:addButton("play_button.png", self.onPlayClick)
	
	-- add option button
	self:addButton("option_button.png", self.onOptionClick)
	
	--position menu in center
	self.menu:setPosition((conf.width-self.menu:getWidth())/2, (conf.height-self.menu:getHeight())/3)
	
end

function MenuScene:addButton(imageUrl, onclick)

	local buttonImage = Bitmap.new(Texture.new("asset/button/" .. imageUrl, conf.textureFilter))
	buttonImage:setScale(0.75)
	
	local buttonUp = buttonImage
	local buttonDown = buttonImage
	buttonDown:setPosition(1,1)
	local button = Button.new(buttonUp, buttonDown)
	
	if onclick ~= nil then
		button:addEventListener("click", onclick, self)
	end
	
	self.menu:addChild(button)
	
end

function MenuScene:onPlayClick()
	sceneManager:changeScene("play", 1, conf.transition, conf.easing)
end

function MenuScene:onOptionClick()
	sceneManager:changeScene("option", 1, conf.transition, conf.easing)
end