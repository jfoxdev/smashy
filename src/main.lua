Gamestate = require "hump.gamestate"
Timer = require "hump.timer"

require "titlescreen"
require "level"
require "credits"

screen = {}
screen.scale_x = love.window.getWidth() / 1024 
screen.scale_y = love.window.getHeight() / 768

ambience = {}
ambience.rain= nil
ambience.wind = nil
ambience.storm = nil
ambience.birds = nil
ambience.crickets = nil
ambience.campfire = nil

music = {}
music.jazz = love.audio.newSource("data/audio/Clazzic.ogg")
music.menu = love.audio.newSource("data/audio/menu.ogg", "stream")
--music.sunny = 
--music.rainy = 
--music.rainy = 

sounds = {}
sounds.smash = love.audio.newSource("data/audio/smash.ogg", "static")
sounds.pop = love.audio.newSource("data/audio/pop.ogg", "static")


game = {}
game.level = 1
game.score = 0
game.combo = 1
game.combo_breaks = 0
game.smashes = 0
game.lives = 3
game.power_mod = 1
game.speed_mod = 1
game.size_mod = 1
game.track = nil


function love.conf(t)
    t.window.width = 1024 -- t.screen.width in 0.8.0 and earlier
    t.window.height = 768 -- t.screen.height in 0.8.0 and earlier
end

function love.load()
	print("Loading Smashy")
	print("Audio Track:  Oreck - Clazzic")
	--love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setColor(255,255,255)

	-- Start Music
	sounds.pop:setVolume(0)
	sounds.smash:setVolume(0)
	
	game.track = music.jazz
	game.track:setVolume(0.9)
	game.track:setLooping(true)
	game.track:play()
	
	Gamestate.registerEvents()
	Gamestate.switch(titlescreen)

end

function love.update(dt)
	--Update Timer
	Timer.update(dt)
	--Update Gamestate
	Gamestate.update(dt)
end


function love.draw()

    love.graphics.scale(screen.scale_x, screen.scale_y)

 	Gamestate.draw()

    
end

function love.resize()
	screen.scale_x = love.window.getWidth() / 1024 
	screen.scale_y = love.window.getHeight() / 768
end

function love.quit()	
	
	game.track:stop()
	print("Did you have a Smashy time?")
end


function love.keypressed(key)
	
	if key == "f11" then
		if love.window.getFullscreen() then
			love.window.setFullscreen( false )
		else
			love.window.setFullscreen( true )
		end
	end
end

-- Load Resources

-- Show TitleScreen

-- Show Menu

-- Launch Game

  -- MainLoop
  
-- Exit
