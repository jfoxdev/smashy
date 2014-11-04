ball = {}
ball.x = 0
ball.y = 0
ball.radius = 16
ball.color = {r = 200, g = 200, b = 200, a = 150}
ball.fired = false
ball.myPaddle = nil
ball.psys = nil
ball.id = 0

function ball:new (o)
	--print("Ball:new()")
	o = o or {
		fired = false,
		myPaddle = nil,
		body = nil,
		shape = nil,
		fixture = nil,
		psys = nil,
		id = 0	
	};   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function ball:load(world, parentPaddle)

	if parentPaddle ~= nil then
		self.myPaddle = parentPaddle
		self.x = self.myPaddle.body:getX() + self.myPaddle.width/2
		self.y = self.myPaddle.body:getY()		
	else
		self.myPaddle = nil
		self.x = math.random(0,level.xmax)
		self.y = math.random(0,level.ymax)
	end


	self.radius = 16
	
	self.max_speed = 150
	if self.body == nil then
		self.body = love.physics.newBody( world, self.x, self.y, "dynamic" )
	end
	self.body:setMass(20) 
	if self.shape == nil then
		self.shape = love.physics.newCircleShape( self.radius )
	end
	
	if self.fixture == nil then
		self.fixture = love.physics.newFixture(self.body, self.shape)
	end
	self.fixture:setRestitution(1)
	self.fixture:setUserData({type="Ball",value=self.id})
	
	self.particle_texture = love.graphics.newImage("data/ball-particle.png")
	self.psys = love.graphics.newParticleSystem(self.particle_texture, 100 )
	self.psys:setEmitterLifetime(-1)
	self.psys:setLinearAcceleration(0,0)
	self.psys:setSpin( 0, 2*math.pi )
	self.psys:setSpinVariation(1)
	self.psys:setParticleLifetime(0.75,1, 1.5)
	self.psys:setColors(200,200,200,100)
	self.psys:setSizes(0.25,0.5,0.75,1)
	self.psys:setEmissionRate(10)
	
	self.psys:start()

end

function ball:update(dt)
	
	self.psys:update( dt )
	self.psys:setPosition(self.body:getX(), self.body:getY())
		
	--if not fire, move with parentPaddle
	if self.fired == false 
	 and self.myPaddle ~= nil  then
		self.body:setX(self.myPaddle.body:getX())
	end
	
	--check OOB collisions
	if self.body:getX() - self.radius < level.xmin then
		self.body:applyLinearImpulse(50, 0)
		sounds.pop:play()
	end
	if self.body:getX() + self.radius > level.xmax then
		self.body:applyLinearImpulse(-50, 0)
		sounds.pop:play()
	end
	
	if self.body:getY() - self.radius < level.ymin then
		self.body:applyLinearImpulse(0, 50)
		sounds.pop:play()
	end
	if self.body:getY() + self.radius > level.ymax then
		self.body:applyLinearImpulse(0, -50)
		sounds.pop:play()
		game.combo_breaks = game.combo_breaks + 1
		game.combo = 1
	end
	
	
	vx,vy = self.body:getLinearVelocity()
	if vx > self.max_speed then vx = self.max_speed end
	if vx < -self.max_speed then vx = -self.max_speed end
	if vy > self.max_speed then vy = self.max_speed end
	if vy < -self.max_speed then vy = -self.max_speed end
	self.body:setLinearVelocity(vx,vy)

end

function ball:draw()
	self.psys:setColors(self.color.r,self.color.g,self.color.b,self.color.a)

	love.graphics.draw(self.psys,0, 0)
			
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
	--love.graphics.circle("fill", self.x, self.y, self.radius, 64)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius, 64)	
    love.graphics.setColor(255,255,255,175)
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.radius, 64)

end


function ball:fire()

	-- impulse
	if self.fired == false then
		self.body:applyLinearImpulse(0, -50)
		self.fired = true
		level.ball_fired = true
	end
end

function ball:randomFire()

	self.body:applyLinearImpulse(math.random(-50,50), math.random(-50,50))
	
end
