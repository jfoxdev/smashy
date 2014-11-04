default_color = {r = 255, g = 255, b = 255, a = 255}
red_color = {r = 220, g = 75, b = 75, a = 175}
blue_color = {r = 75, g = 75, b = 220, a = 175}
green_color = {r = 75, g = 220, b = 75, a = 175}
yellow_color = {r = 75, g = 220, b = 220, a = 175}

brick_overlay = love.graphics.newImage("data/brick-shadow.png")
brick = {}
brick.x = 0
brick.y = 0
brick.width = 64
brick.height = 32



function brick:new (o)
	--print("Brick:new()")
	o = o or {
		id = 0,
		width = 64,
		height = 32,
		destroyed = false,
		powered = false,
		points = 10,
		body = nil,
		shape = nil,
		fixture = nil,	
		psys = nil	
	};   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end
    
function brick:load(world, x, y, id, width, height)

	if x == nil then x = 0 end
	if y == nil then y = 0 end
	
	self.id = id
	self.x = x
	self.y = y
	self.vel_x = 0
	self.vel_y = 0
	if width ~= nil then self.width = width end
	if height ~= nil then self.height = height end
	
	
	self.color = default_color
	self.color.r = 133
	self.color.g = 133
	self.color.b = 200
	
	self.body = love.physics.newBody( world, self.x+self.width/2, self.y+self.height/2, "static" )	
	self.body:setMass(20) 

	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setRestitution(1)
	self.fixture:setUserData({type="Brick",value=self.id})
	
	self.particle_texture = love.graphics.newImage("data/glass-particle.png")
	self.psys = love.graphics.newParticleSystem(self.particle_texture, 100 )
	self.psys:setPosition(self.body:getX(), self.body:getY())
	self.psys:setAreaSpread(normal, self.width/2, self.height/2)
	self.psys:setSpread(math.pi )
	self.psys:setEmitterLifetime(0.75)
	--self.psys:setLinearAcceleration(0,0)
	self.psys:setDirection(math.pi/2)
	self.psys:setSpeed(0,50)
	self.psys:setSpin( 0, 2*math.pi )
	self.psys:setSpinVariation(1)
	self.psys:setParticleLifetime(0.75,1, 1.5)
	self.psys:setColors(self.color.r,self.color.g,self.color.b,self.color.a)
	self.psys:setSizes(0.5,1,0.1)
	self.psys:setEmissionRate(100)
	--print("Brick Loaded: (" .. self.x .. ",".. self.y .. ")")
end

function brick:update(dt)	
	self.psys:update( dt )
   
end

function brick:draw()

	if self.body ~= nil then
	  	self.psys:setColors(self.color.r,self.color.g,self.color.b,self.color.a - 100)
		--love.graphics.draw(self.psys, self.body:getX(), self.body:getY())
		love.graphics.draw(self.psys,0, 0)
		
		if self.destroyed == false then
			love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
			love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
			--love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), self.width, self.height)

			love.graphics.setColor(255,255,255,125)
			love.graphics.draw(brick_overlay, self.body:getX()-self.width/2, self.body:getY()-self.height/2)

			love.graphics.setColor(255,255,255,200)
			love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
			--love.graphics.rectangle("line", self.body:getX(), self.body:getY(), self.width, self.height)

		end
	end
end


function brick:setDestroy()
	self.destroyed = true
    self.psys:reset()
    self.psys:start()    

	--if self.powered then powerup:new()
	sounds.smash:play()
	game.smashes = game.smashes + 1
	game.score = game.score + (game.combo * self.points)

end    

function brick:destroy()
    self.body:setActive(false) 
end   
