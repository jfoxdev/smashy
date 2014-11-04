powerup = {}
powerup.x = 0
powerup.y = 0
powerup.radius = 16
powerup.color = {r = 250, g = 250, b = 250, a = 150}
powerup.psys = nil
powerup.id = 0
powerup.type = nil

function powerup:new (o)
	--print("Powerup:new()")
	o = o or {
		x = 0,
		y = 0,
		radius = 16,
		color = {r = 250, g = 250, b = 250, a = 150},
		psys = nil,
		id = 0,
		type = nil
	};   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function powerup:load(world, x, y, pu_type, id)

	self.radius = 16
	self.body:setMass(20) 	
	self.speed = 15

	if pu_type == "Speed"
		--self.overlay = love.graphics.newImage("data/powerup-speed.png")
	end
	if pu_type == "Size"
		--self.overlay = love.graphics.newImage("data/powerup-size.png")
	end
	if pu_type == "Power"
		--self.overlay = love.graphics.newImage("data/powerup-power.png")
	end	
	if pu_type == "Multi"
		--self.overlay = love.graphics.newImage("data/powerup-multi.png")
	end
	


	
	if self.body == nil then
		self.body = love.physics.newBody( world, self.x, self.y, "dynamic" )
	end
	if self.shape == nil then
		self.shape = love.physics.newCircleShape( self.radius )
	end
	if self.fixture == nil then
		self.fixture = love.physics.newFixture(self.body, self.shape)
	end
	
	self.fixture:setRestitution(1)
	self.fixture:setUserData({type="Powerup",value=self.id})
	
	self.particle_texture = love.graphics.newImage("data/powerup-particle.png")
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

function powerup:update(dt)
	
	self.psys:update( dt )
	self.psys:setPosition(self.body:getX(), self.body:getY())
		
	

end

function powerup:draw()
	self.psys:setColors(self.color.r,self.color.g,self.color.b,self.color.a)

	love.graphics.draw(self.psys,0, 0)
			
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius, 64)
    
    --draw self.overlay
    	
    love.graphics.setColor(255,255,255,175)
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.radius, 64)

end


function powerup:collect()

	if pu_type == "Speed"
		--self.overlay = love.graphics.newImage("data/powerup-speed.png")
	end
	if pu_type == "Size"
		--self.overlay = love.graphics.newImage("data/powerup-size.png")
	end
	if pu_type == "Power"
		--self.overlay = love.graphics.newImage("data/powerup-power.png")
	end	
	if pu_type == "Multi"
		--self.overlay = love.graphics.newImage("data/powerup-multi.png")
	end

end

