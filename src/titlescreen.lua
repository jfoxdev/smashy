require "highscores"
require "level"
require "credits"
require "button"

titlescreen = {}

function titlescreen:enter()

	--self.audio = love.sound.newSoundData("data/audio/menu.ogg")
	--self.audio_src = love.audio.newSource(self.audio, "stream")
	--self.audio_src:play()
	
    love.graphics.setColor(0,0,0)
    titlescreen.background = love.graphics.newImage("data/titlescreen.png")
	
	
	--titlescreen.world = love.physics.newWorld(level.xmin,level.ymin,level.xmax,level.ymax)
	titlescreen.world = love.physics.newWorld(0,0,true)
    titlescreen.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	love.physics.setMeter(64) -- set 64 pixels/meter	
	
	
	lol_balls = {}
	
	for i=0,10 do
		lol_balls[i] = ball:new()
		lol_balls[i]:load(titlescreen.world)
	end
	
	for i=0,10 do	
		lol_balls[i]:randomFire()
	end
	
--[[	if game.level == 1 then 
		play_text = "New Game" 
	else
		play_text = "Continue"
	end ]]

	button_spawn(650,450, "New Smashy!", "new")
	button_spawn(650,550, "Highscores", "highscores")
	button_spawn(650,650, "Quit", "quit")
	
	titlescreen.cursor = love.mouse.newCursor( love.image.newImageData("data/cursor.png"), 0, 0 )
	love.mouse.setCursor(titlescreen.cursor)
	love.mouse.setVisible(true)
	
	sounds.pop:setVolume(0)
	sounds.smash:setVolume(0)
end

function titlescreen:resume()
	button_spawn(650,500, "New Smashy!", "new")
	button_spawn(650,600, "Highscores", "highscores")
	button_spawn(650,700, "Quit", "quit")
	
	love.mouse.setVisible(true)
end

function titlescreen:leave()
	clear_all_buttons()
	self.world:destroy()
end


function titlescreen:update(dt)
	self.world:update(dt)
	for i=0,10 do
		lol_balls[i]:update(dt)
	end	
	
	button_hover(love.mouse.getX(), love.mouse.getY())
    button_update()

end

function titlescreen:draw()
	love.graphics.setColor(255,255,255,255)
    love.graphics.draw(titlescreen.background, 0, 0)
 	
 	for i=0,10 do
		lol_balls[i]:draw()
	end	
	   
    --button_draw()
    button_draw_id("new")
    button_draw_id("highscores")
    button_draw_id("quit")
    
end

function titlescreen:keypressed(key)
    if key == 'return' then
        --Gamestate.switch(new_level)
        Gamestate.switch(level)
    end
    
    if key == 'escape' then
        Gamestate.switch(credits)
    end
    
    if key == 'f1' then
        Gamestate.switch(highscores)
    end
end

function titlescreen:mousereleased(x,y)
	button_click(x, y)
end
