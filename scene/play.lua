PlayScene = gideros.class(Sprite)

local boardW, boardH = 250, 350
local posX, posY = 110, 290
local row, column = 7, 5

local fruitW = boardW / column
local fruitH = boardH / row

local matrix = {}
local numberOfMarkedToDestroy = 0

local board = Shape.new()

function PlayScene:init()

	-- add background screen
	local background = Bitmap.new(Texture.new("asset/background/bg_lvl1.png", conf.textureFilter))
	background:setAnchorPoint(0.5,0.5)
	background:setPosition(application:getContentWidth()/2,application:getContentHeight()/2)
	self:addChild(background)
	
	-- matrix container
	board:setFillStyle(Shape.SOLID, 0xffffff, 0.5)   
	board:beginPath(Shape.NON_ZERO)
	board:moveTo(posX, posY)
	board:lineTo(posX + boardW, posY)
	board:lineTo(posX + boardW, posY + boardH)
	board:lineTo(posX, posY + boardH)
	board:lineTo(posX, posY)
	board:endPath()
	self:addChild(board)
	
	-- initialize matrix
	self:generate(column, row, 7)
end

-- generate fruit matrix
function PlayScene:generate(x, y, n)
	
	for i=1,x do
		matrix[i] = {}
		for j=1,y do
			local fruit = Fruit.new(math.random(n))
			
			fruit:addEventListener(Event.MOUSE_DOWN, onMouseDown, fruit)
			fruit:addEventListener(Event.MOUSE_MOVE, onMouseMove, fruit)
			fruit:addEventListener(Event.MOUSE_UP, onMouseUp, fruit)
			
			matrix[i][j] = fruit
			board:addChild(fruit)
		end
	end
	
	updateVisualState()
	
end

-- on image mouse down
function onMouseDown(this, event)
	if this:hitTestPoint(event.x, event.y) then
		this.isFocus = true
 
		this.x0 = event.x
		this.y0 = event.y
 
		event:stopPropagation()
	end
end

-- on image mouse moveTo
function onMouseMove(this, event)
	if this.isFocus then
		local dx = event.x - this.x0
		local dy = event.y - this.y0
 
		this:setX(this:getX() + dx)
		this:setY(this:getY() + dy)
 
		this.x0 = event.x
		this.y0 = event.y
 
		event:stopPropagation()
	end
end

-- on image mouse up
function onMouseUp(this, event)
	if this.isFocus then
		
		local tempx, tempy = this:getInitialPosition()
		
		-- jika posisi masih berada pada area papan
		if (onBoard(event.x, event.y)) then
			
			-- jika posisi masih berada pada area tetangga sebelah
			if (event.x >= (tempx - (fruitW*1.5)) and event.x <= (tempx + (fruitW*1.5)) and
				event.y >= (tempy - (fruitH*1.5)) and event.y <= (tempy + (fruitH*1.5))) then
				
				-- swap fruit
				local neighborX, neighborY = getIndex(event.x, event.y)
				local tempX, tempY = getIndex(this:getInitialPosition())
				
				local current = matrix[tempX][tempY]
				local neighbor = matrix[neighborX][neighborY]
				
				matrix[tempX][tempY] = neighbor
				matrix[neighborX][neighborY] = current
				
				markToDestroy(current)
				if numberOfMarkedToDestroy >= 3 then
					destroyFruits()
				else 
					print(numberOfMarkedToDestroy)
					cleanUpFruits()
					matrix[tempX][tempY] = current
					matrix[neighborX][neighborY] = neighbor
				end
				
				updateVisualState()
			else
			
				this:setPosition(tempx, tempy)
				
			end
		else
		
			this:setPosition(tempx, tempy)
			
		end
		
		this.isFocus = false
		event:stopPropagation()
	end
end

-- check if current position located on the board
function onBoard(x, y)
	return (x > posX and x < posX + boardW and y > posY and y < posY + boardH)
end

-- get the matrix index of the current position
function getIndex(x, y)
	
	for i=1,column do
		for j=1,row do
		
			local fruitX, fruitY = matrix[i][j]:getInitialPosition()
			fruitX = fruitX - (fruitW / 2)
			fruitY = fruitY - (fruitH / 2)
			
			if (x >= fruitX and x < fruitX + fruitW and y > fruitY and y < fruitY + fruitH) then
				return i, j
			end
			
		end
	end
	
	return nil, nil
	
end

-- update visual state
function updateVisualState()
	for i=1,column do
		for j=1,row do
		
			local fruitX = posX + ((i-1) * fruitW) + (fruitW / 2)
			local fruitY = posY + ((j-1) * fruitH) + (fruitH / 2)
			
			matrix[i][j]:setPosition(fruitX, fruitY)
			matrix[i][j]:setInitialPosition(fruitX, fruitY)
			matrix[i][j]:setIndex(i,j)
			matrix[i][j].isFocus = false
			
		end
	end
end

function markToDestroy(this)

	this.isMarkedToDestroy = true
	numberOfMarkedToDestroy = numberOfMarkedToDestroy + 1
	
	-- check on the left
	if this.i>1 then
		if (matrix[this.i-1][this.j]).isMarkedToDestroy == false then
			if (matrix[this.i-1][this.j]).fruitType == this.fruitType then
			   markToDestroy(matrix[this.i-1][this.j])
			end	 
		end
	end

	-- check on the right
	if this.i<column then
		if (matrix[this.i+1][this.j]).isMarkedToDestroy == false then
			if (matrix[this.i+1][this.j]).fruitType == this.fruitType then
			    markToDestroy(matrix[this.i+1][this.j])
			end	 
		end
	end

	-- check above
	if this.j>1 then
		if (matrix[this.i][this.j-1]).isMarkedToDestroy == false then
			if (matrix[this.i][this.j-1]).fruitType == this.fruitType then
			   markToDestroy(matrix[this.i][this.j-1])
			end	 
		end
	end

	-- check below
	if this.j<row then
		if (matrix[this.i][this.j+1]).isMarkedToDestroy == false then
			if (matrix[this.i][this.j+1]).fruitType == this.fruitType then
			   markToDestroy(matrix[this.i][this.j+1])
			end	 
		end
	end
end

function destroyFruits()
	print ("Destroying Fruits. Marked to Destroy = "..numberOfMarkedToDestroy)

	for i = 1, column do
		for j = 1, row do
			--print(i .. "," .. j)
			if matrix[i][j].isMarkedToDestroy then
				board:removeChild(matrix[i][j])
				
				fruitToBeDestroyed = matrix[i][j]
				
				local fruit = Fruit.new(math.random(7))
				fruit:addEventListener(Event.MOUSE_DOWN, onMouseDown, fruit)
				fruit:addEventListener(Event.MOUSE_MOVE, onMouseMove, fruit)
				fruit:addEventListener(Event.MOUSE_UP, onMouseUp, fruit)
				
				matrix[i][j] = fruit
				board:addChild(fruit)
				
				-- destroy old fruit
				--fruitToBeDestroyed:removeSelf()
				--fruitToBeDestroyed = nil
				
				--isGemTouchEnabled = false
				--transition.to( gemsTable[i][j], { time=300, alpha=0.2, xScale=2, yScale = 2, onComplete=enableGemTouch } )

				-- update score
				--score = score + 10
				--scoreText.text = string.format( "SCORE: %6.0f", score )
				--scoreText:setReferencePoint(display.TopLeftReferencePoint)
				--scoreText.x = 60
				
			end
		end
	end

	numberOfMarkedToDestroy = 0
	--updateVisualState()
	--shiftFruits()
	--timer.performWithDelay( 320, shiftGems )
end

function cleanUpFruits()
	print("Cleaning Up Fruits")
		
	numberOfMarkedToDestroy = 0
	
	for i = 1, column do
		for j = 1, row do
			
			-- show that there is not enough
			if matrix[i][j].isMarkedToDestroy then
				--transition.to( gemsTable[i][j], { time=100, xScale=1.2, yScale = 1.2 } )
				--transition.to( gemsTable[i][j], { time=100, delay=100, xScale=1.0, yScale = 1.0} )
			end

			matrix[i][j].isMarkedToDestroy = false
		end
	end
end

--[[
function shiftFruits()
	print ("Shifting Gems")

	-- first row
	for i = 1, column do
		if matrix[i][1].isMarkedToDestroy then

			-- current gem must go to a 'gemToBeDestroyed' variable holder to prevent memory leaks
			-- cannot destroy it now as gemsTable will be sorted and elements moved down
			fruitToBeDestroyed = matrix[i][1]
			
			-- create a new one
			matrix[i][1] = Fruit.new(i,1)
			
			-- destroy old fruit
			fruitToBeDestroyed:removeSelf()
			fruitToBeDestroyed = nil
		end
	end

	-- rest of the rows
	for j = 2, row do  -- j = row number - need to do like this it needs to be checked row by row
		for i = 1, column do
			if matrix[i][j].isMarkedToDestroy then --if you find and empty hole then shift down all gems in column

				fruitToBeDestroyed = matrix[i][j]
			
				-- shiftin whole column down, element by element in one column
				for k = j, 2, -1 do -- starting from bottom - finishing at the second row

					-- curent markedToDestroy Gem is replaced by the one above in the gemsTable
					matrix[i][k] = gemsTable[i][k-1]
					matrix[i][k].destination_y = gemsTable[i][k].destination_y +40
					transition.to( gemsTable[i][k], { time=100, y= gemsTable[i][k].destination_y} )
					
					-- we change its j value as it has been 'moved down' in the gemsTable
					gemsTable[i][k].j = gemsTable[i][k].j + 1
			
				end

				-- create a new gem at the first row as there is en ampty space due to gems
				-- that have been moved in the column
				gemsTable[i][1] = newGem(i,1)

				-- destroy the old gem (the one that was invisible and placed in gemToBeDestroyed holder)
				gemToBeDestroyed:removeSelf()
				gemToBeDestroyed = nil
			end 
		end
	end
end
]]--