--[[
*************************************************************
 * FRUIT MATCH 3
 * 
 * Authors:
 * - Abyasa Widiarta	23513020
 * - Ikhsan Fanani		23513065
 * 
 * Disusun untuk memenuhi salah satu tugas pada mata kuliah
 * IF5152 - Pengembangan Aplikasi Piranti Bergerak
 * 
**************************************************************
]]--

-- load box2d
require "box2d"

--setting up some configurations
application:setOrientation(conf.orientation)
application:setLogicalDimensions(conf.width, conf.height)
application:setScaleMode(conf.scaleMode)
application:setFps(conf.fps)
application:setKeepAwake(conf.keepAwake)

--get new dimensions
conf.width = application:getContentWidth()
conf.height = application:getContentHeight()

--create settings instance
sets = Settings.new()

-- load texture pack
--assets = TexturePack.new("asset/texturepack.txt", "asset/texturepack.png", true)

conf.transition = SceneManager.flipWithFade
conf.easing = easing.outBack

--load packs and level amounts from packs.json
packs = dataSaver.load("packs")

--if sets not define (first launch)
--define defaults
if(not sets) then
	sets = {}
	sets.sounds = true
	sets.music = true
	sets.curLevel = 1
	sets.curPack = 1
	dataSaver.saveValue("sets", sets)
end

--background music
music = {}

--load main theme
music.theme = Sound.new("audio/main.mp3")

--turn music on
music.on = function()
	if not music.channel then
		music.channel = music.theme:play(0,1000000)
		sets.music = true
		dataSaver.saveValue("sets", sets)
	end
end

--turn music off
music.off = function()
	if music.channel then
		music.channel:stop()
		music.channel = nil
		sets.music = false
		dataSaver.saveValue("sets", sets)
	end
end

--play music if enabled
if sets.music then
	music.channel = music.theme:play(0,1000000)
end

--sounds
sounds = {}

--load all your sounds here
--after that you can simply play them as sounds.play("hit")
sounds.complete = Sound.new("audio/complete.mp3")
sounds.hit = Sound.new("audio/hit.wav")

--turn sounds on
sounds.on = function()
	sets.sounds = true
	dataSaver.saveValue("sets", sets)
end

--turn sounds off
sounds.off = function()
	sets.sounds = false
	dataSaver.saveValue("sets", sets)
end

--play sounds
sounds.play = function(sound)
	--check if sounds enabled
	if sets.sounds and sounds[sound] then
		sounds[sound]:play()
	end
end

--function for creating menu buttons
menuButton = function(image, container, current, all)
	local buttonUp = Bitmap.new(Texture.new(image))
	local buttonDown = Bitmap.new(Texture.new(image))
	buttonDown:setPosition(1,1)
	local newButton = Button.new(buttonUp, buttonDown)
	local startHeight = (current-1)*(container:getHeight())/all + (((container:getHeight())/all)-newButton:getHeight())/2 + application:getContentHeight()/16
	newButton:setPosition((application:getContentWidth()-newButton:getWidth())/2, startHeight)
	return newButton;
end 

--define scenes
sceneManager = SceneManager.new({
	--menu scene
	["menu"] = MenuScene,
	--settings scene
	["option"] = OptionScene,
	--level select scene
	["level"] = LevelScene,
	--credit scene
	["credit"] = CreditScene,
	--result scene
	["result"] = ResultScene,
	--play scene
	["play"] = PlayScene
})
--add manager to stage
stage:addChild(sceneManager)

--start start scene
sceneManager:changeScene("menu", 1, conf.transition, conf.easing)