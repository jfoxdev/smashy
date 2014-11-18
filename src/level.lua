require "paddle"
require "ball"
require "brick"

require "pausing"
require "winning"
require "losing"

styles = {}
styles.img = nil
styles.sound_ambient = nil
styles.sound_track = nil

level = {}

level.xmin = 0
level.xmax = 1024
level.ymin = 0
level.ymax = 768
level.completed = false
level.ball_fired = false



--[[
level.brickcount = 0
level.remaining = nil
 ]]

destroyed_bricks = {}

function level:new (o)
	print("Level:new()")
	o = o or { -- create object if user does not provide one
		xmin = 0,
		xmax = 1024,
		ymin = 0,
		ymax = 768,
		brickcount = 0,
		bricks = {},
		remaining = nil,
		completed = false,
		ball_fired = false

	};   
	setmetatable(o, self)
	self.__index = self
	return o
end

function level:load(grid)
	print("Level:load("..grid..")")
	--reset combos broken
	game.combo_breaks = 0
	game.combo = 1
	
	self.paddle:load(self.world)
	self.ball:load(self.world, self.paddle)

    self.brickcount = 0
 	--self.bricks = nil	
 	self.bricks = {}	
	self:loadGrid(grid)
	self.remaining = self.brickcount	
	self.completed = false		
	self.ball_fired = false
	sounds.pop:setVolume(0.6)
	sounds.smash:setVolume(0.6)
end	


function level:enter(last_state)
	
    love.graphics.setBackgroundColor(25,25,25)    
    self.background = love.graphics.newImage("data/backgrounds/sky.png")
    love.graphics.setColor(0,0,0)
    love.mouse.setVisible( false )  
    
	--self.world = love.physics.newWorld(level.xmin,level.ymin,level.xmax,level.ymax)
	self.world = love.physics.newWorld(0,0,true)
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  
	love.physics.setMeter(64) -- set 64 pixels/meter

	self.paddle = paddle:new() 	
  	
	self.ball = ball:new()	


 	--if self.number == 0 then self.number = 1 end
	local grid = "grid-"..game.level
    self:load(grid)    

end

function level:leave()
	--self.world:destroy()
	
	for k in pairs (self.bricks) do
		self.bricks[k] = nil
	end
--	for i,v in ipairs(self.bricks) do
--		v = nil
--	end	

	self.ball = nil
	self.paddle = nil
	
end


function level:update(dt)

	self.world:update(dt)
	
--	for i = 0,  #self.bricks do
--		self.bricks[i]:update(dt)
--	end
	for i,v in ipairs(self.bricks) do
		v:update(dt)
	end	


	
	
	--powerup.update(dt)
	--keep paddle within level
	
	
	-- let the mouse move the paddle
	self:mouse_move(love.mouse.getX(), love.mouse.getY())

	self.paddle:update(dt)
	self.ball:update(dt)
	
--	for i = 0,  #self.bricks do	
--		if self.bricks[i].destroyed then
--			self.bricks[i]:destroy()
--		end
--	end
	
	for i,v in ipairs(self.bricks) do
		if v.destroyed then
			v:destroy()
		end
	end	
		
	if self.remaining == 0 
	 and self.completed == false then
		-- YOU WIN!
		game.level = game.level + 1
		Timer.add(0.75, function() Gamestate.switch(winning) end )
		self.completed = true
	end
	

end

function level:draw()
    --love.graphics.print("Level 1", 400, 300)	
    
    -- Draw Background     
    love.graphics.setBackgroundColor(25,25,25)    
    love.graphics.setColor(255,255,255,100)
	love.graphics.draw(self.background, 0, 0)

	--draw bricks

--	for i = 0,  #self.bricks do
--		--print("Drawing Brick[".. i .."]:(".. level.bricks[i].x .. ",".. level.bricks[i].y ..")")
--		self.bricks[i]:draw()
--	end	
	
	for i,v in ipairs(self.bricks) do
		v:draw()
	end	
		
    self.paddle:draw()
	self.ball:draw()
	--powerup.draw()
end

function level:loadGrid(filename)

	if not love.filesystem.exists("data/grids/"..filename) then 
		self:randomizeGrid()
	else		
		math.randomseed( os.time() ) -- for powerups
		file = love.filesystem.newFile("data/grids/"..filename)
		file:open("r")
		data = file:read()
		
		self.brickcount = 0
		local offset = 0
		local row = 0
		
		-- foreach brick in brick.grid
		for line in love.filesystem.lines("data/grids/" .. filename) do
			
			for i = 1, #line do
				
				local c = line:sub(i,i)
				
				if c == "-" then 
					--print("space")
					offset = offset + brick.width
				else
					
					--print("BRICK")				
					--print("Offset "..offset.." row "..row)	
					local br = brick:new()
					br:load(self.world, offset,row, self.brickcount)

					--self.bricks[self.brickcount] = brick:new()
					--self.bricks[self.brickcount]:load(self.world, offset,row, self.brickcount)
			
					--if c == "1" then self.bricks[self.brickcount].color = red_color	end
					--if c == "2" then self.bricks[self.brickcount].color = blue_color	end
					--if c == "3" then self.bricks[self.brickcount].color = green_color	end
					--if c == "4" then self.bricks[self.brickcount].color = yellow_color	end									
					
					if c == "1" then 
						br.color = red_color
						br.points = 25	
					end
					if c == "2" then 
						br.color = blue_color	
						br.points = 50	
					end
					if c == "3" then 
						br.color = green_color
						br.points = 75	
					end
					if c == "4" then 
						br.color = yellow_color
						br.points = 100		
					end		
					
					
					-- 1 in 10 chance of powerup
					if math.random(0,10) == 1 then br.powered = true end
					
												
					table.insert(self.bricks, br)
							
					self.brickcount = self.brickcount + 1				
					offset = offset + brick.width
				end
				
			end
		  
		  row = row + brick.height
		  offset = 0
		  print(line) -- for debugging purposes
		  
		end
	   
		file:close()
	end
end


function level:randomizeGrid()
	math.randomseed( os.time() )
	
	self.brickcount = 0
	offset = 0
	row = 0
	
	colmax = self.xmax / brick.width
	rowmax = (self.ymax / brick.height) - 5
	
	rows = math.random(3, rowmax)
	
	--for i < rowmax	
	for i=1,rows do
		
		for j=1,colmax do	
			local n = math.random(0,4)
			
			if n == 0 then 
			offset = offset + brick.width
			else
				--print("BRICK")				
				--print("Offset "..offset.." row "..row)					
				
				local br = brick:new()
				br:load(self.world, offset,row, self.brickcount)

				--level.bricks[level.brickcount].x = offset * 128
				--level.bricks[level.brickcount].y = row * 32
				
				if n == 1 then self.bricks[self.brickcount].color = red_color	end
				if n == 2 then self.bricks[self.brickcount].color = blue_color	end
				if n == 3 then self.bricks[self.brickcount].color = green_color	end
				if n == 4 then self.bricks[self.brickcount].color = yellow_color	end
				
				if n == "1" then 
					br.color = red_color
					br.points = 25	
				end
				if n == "2" then 
					br.color = blue_color	
					br.points = 50	
				end
				if n == "3" then 
					br.color = green_color
					br.points = 75	
				end
				if n == "4" then 
					br.color = yellow_color
					br.points = 100		
				end					
				
				-- 1 in 10 chance of powerup
				if math.random(0,10) == 1 then br.powered = true end
					
				table.insert(self.bricks, br)
									
				self.brickcount = self.brickcount + 1				
				offset = offset + brick.width		
				
			end
		
		end
		row = row + brick.height
		offset = 0			
    end   

      

end

function level:keypressed(key)
    if key == 'escape' then
        Gamestate.push(pausing)
    end
end

function level:mousereleased(x,y)
	self.ball:fire()
end

function level:mouse_move(x, y)
	self.paddle.body:setX(x / screen.scale_x)
	--paddle.body:setIntertia( 0)
end

function level:destroyBrick(id)
  	print("Destroy Brick: "..id)  

--[[	for i=0,#self.bricks do
		if self.bricks[i].id == id then 
			--level.bricks[i].psys:reset() 
			--level.bricks[i].psys:start() 
			self.bricks[i]:setDestroy()
			self.remaining = self.remaining - 1 
			print("Bricks Remaining: "..self.remaining)
		end
	end]]
	
	for i,v in ipairs(self.bricks) do
		if v.id == id then 
			--level.bricks[i].psys:reset() 
			--level.bricks[i].psys:start() 
			v:setDestroy()
			self.remaining = self.remaining - 1 
			print("Bricks Remaining: "..self.remaining)
		end
	end	
	
end

function beginContact(a, b, coll)
    x,y = coll:getNormal()
    
    a_data = a:getUserData()
    b_data = b:getUserData()
    
    local x1, y1, x2, y2 = coll:getPositions()		

    
	if a_data.type == "Brick" then
	--	print("Brick Collision!")
		level:destroyBrick(a_data.value)
				
		pshape = a:getShape()
		x_bounce = (((a:getBody():getX() + (2 * pshape:getRadius())) - x1 ) - (pshape:getRadius()))
		y_bounce = (((a:getBody():getY() + (2 * pshape:getRadius())) - y1 ) - (pshape:getRadius()))
		b:getBody():applyLinearImpulse(x_bounce, y_bounce)
	end
		
    if a_data.type  == "Paddle" then
		--print("Paddle Collision!")
		
		if level.ball_fired	and game.combo < 4 then
			game.combo = game.combo + 1
		end

		pshape = a:getShape()
		x_bounce = (((a:getBody():getX() + (2 * pshape:getRadius())) - x1 ) - (pshape:getRadius())) / 10

		if level.ball_fired then
			sounds.pop:play()
			b:getBody():applyLinearImpulse(x_bounce, 10)
		end
    end  	
     
    
end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
    
    
end
