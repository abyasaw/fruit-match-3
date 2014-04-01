OptionScene = gideros.class(Sprite)

function OptionScene:init()

	-- add background screen
	local background = Bitmap.new(Texture.new("asset/background/bg_optionmenu.png", conf.textureFilter))
	background:setAnchorPoint(0.5,0.5)
	background:setPosition(application:getContentWidth()/2,application:getContentHeight()/2)
	self:addChild(background)
	
	-- add menu button
	self:addButton("menu.png", 0.33, self.onMenuClick)
	
	-- add sound button
	--self:addButton("sound_on.png", 0.39, self.onSoundClick)
	soundOnImage = Bitmap.new(Texture.new("asset/button/sound_on.png", conf.textureFilter))
	soundOnImage:setScale(0.5)
	soundOnButtonUp = soundOnImage
	soundOnButtonDown = soundOnImage
	soundOnButtonDown:setPosition(1,1)
	soundOnButton = Button.new(soundOnButtonUp, soundOnButtonDown)
	soundOnButton:setPosition((application:getContentWidth()-soundOnButton:getWidth())/2, application:getContentHeight()*0.39)
	
	soundOffImage = Bitmap.new(Texture.new("asset/button/sound_off.png", conf.textureFilter))
	soundOffImage:setScale(0.5)
	soundOffButtonUp = soundOffImage
	soundOffButtonDown = soundOffImage
	soundOffButtonDown:setPosition(1,1)
	soundOffButton = Button.new(soundOffButtonUp, soundOffButtonDown)
	soundOffButton:setPosition((application:getContentWidth()-soundOffButton:getWidth())/2, application:getContentHeight()*0.39)
	
	soundOnButton:addEventListener("click",
		function()
			self:removeChild(soundOnButton)
			music.off()
			self:addChild(soundOffButton)
		end
	)
	
	soundOffButton:addEventListener("click",
		function()
			self:removeChild(soundOffButton)
			music.on()
			self:addChild(soundOnButton)
		end
	)
	
	if sets.music then
		self:addChild(soundOnButton)
	else
		self:addChild(soundOffButton)
	end
	
	-- add level select button
	self:addButton("lvl_button.png", 0.45, self.onLevelClick)
	
	-- add about button
	self:addButton("about.png", 0.51, self.onAboutClick)
	
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	
end

function OptionScene:onEnterEnd()

	
end

function OptionScene:addButton(imageUrl, pos, onclick)
	local buttonImage = Bitmap.new(Texture.new("asset/button/" .. imageUrl, conf.textureFilter))
	buttonImage:setScale(0.5)
	local buttonUp = buttonImage
	local buttonDown = buttonImage
	buttonDown:setPosition(1,1)
	local button = Button.new(buttonUp, buttonDown)
	button:setPosition((application:getContentWidth()-button:getWidth())/2, application:getContentHeight()*pos)
	
	if onclick ~= nil then
		button:addEventListener("click", onclick, self)
	end
	
	self:addChild(button)
end

function OptionScene:onMenuClick()
	sceneManager:changeScene("menu", 1, SceneManager.flipWithFade, easing.outBack)
end

function OptionScene:onLevelClick()
	sceneManager:changeScene("level", 1, SceneManager.flipWithFade, easing.outBack)
end

function OptionScene:onAboutClick()
	sceneManager:changeScene("credit", 1, SceneManager.flipWithFade, easing.outBack)
end