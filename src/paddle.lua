paddle = {}
paddle.width = nil
paddle.height = nil
paddle.body = nil
paddle.shape = nil
paddle.fixture = nil
paddle.color = {r = 10, g = 10, b = 10, a = 100}
paddle.id = 0
paddle.score = 0
paddle.lives = 3
paddle.balls = 1


function paddle:new (o)
	print("Paddle:new()")
	o = o or {
		id = 0,
		body = nil,
		shape = nil,
		fixture = nil,
		psys = nil
	
	};   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function paddle:load(world)
	self.width = 128
	self.height = 32
	
	-- center paddle x in level
	self.x = (level.xmax - self.width) / 2
	-- offset paddle y from bottom of level by 1/2 the paddlest height
	self.y = (level.ymax - self.height) - self.height / 2

	self.body = love.physics.newBody( world, self.x, self.y, "static" )	
	self.body:setMass(20) 

	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape)	
	self.fixture:setRestitution(0.1)
	self.fixture:setUserData({type="Paddle",value=self.id})

	self.vel_x = 0
	self.vel_y = 0
	self.speed = 50

end

function paddle:update(dt)

   radius = 64
   
   if love.keyboard.isDown("right") then    
	  self.body:applyForce(1000, 0)
   end
   if love.keyboard.isDown("left") then
      self.body:applyForce(-1000, 0)
   end
   
   
   if self.body:getX() - self.width/2 < level.xmin then
	self.body:setX(level.xmin + self.width/2)
   end	   
   if self.body:getX() + self.width/2 > level.xmax then
	self.body:setX(level.xmax - self.width/2)
   end
   
   
--   if love.keyboard.isDown("down") then
--     paddle.y = paddle.y + (paddle.speed * dt)
--      if paddle.y + paddle.height > level.ymax then
--		paddle.y = level.ymax - paddle.height
--	  end
--   end
--   if love.keyboard.isDown("up") then
--      paddle.y = paddle.y - (paddle.speed * dt)      
--      if paddle.y < level.ymin then
--		paddle.y = level.ymin
--	  end	
--   end
   
end



function paddle:draw()

	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
   -- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    
    love.graphics.setColor(200,200,200,220)	
   -- love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))

end

