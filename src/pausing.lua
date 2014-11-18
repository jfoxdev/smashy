require "button"

pausing = {}

function pausing:enter()

    love.graphics.setBackgroundColor(0,0,0,255)
	--pausing.background = love.graphics.newImage("data/winning.png")

	pausing.text = "Smash...y?"
	pausing.text_paused = "(Paused)"
	pausing.text_escape = "[Escape] for Titlescreen"
	pausing.text_enter = "[Enter] to Smashy!"
	
	love.mouse.setVisible(true)	
	--game.audio_src:pause()

end

function pausing:resume()

end

function pausing:leave()
	love.mouse.setVisible(false)
	--game.audio_src:resume()

end


function pausing:update(dt)

end

function pausing:draw()
	--love.graphics.setColor(255,255,255,255)
    --love.graphics.draw(winning.background, 0, 0)
 		
 	love.graphics.setColor(255,255,50,255)
	love.graphics.setFont(medium)
	love.graphics.print(pausing.text,level.xmax/2 - medium:getWidth(pausing.text)/2, 150)
	
	love.graphics.setFont(tinytext)	
	love.graphics.print(pausing.text_paused,level.xmax/2 - tinytext:getWidth(pausing.text_paused)/2, 150 + medium:getHeight())
	love.graphics.print(pausing.text_escape,level.xmax/2 - tinytext:getWidth(pausing.text_escape)/2, 500)
	love.graphics.print(pausing.text_enter,level.xmax/2 - tinytext:getWidth(pausing.text_enter)/2, 500 + tinytext:getHeight())
		   
    
end

function pausing:keypressed(key)

    if key == 'escape' then
        Gamestate.switch(titlescreen)
    end
    if key == 'return' then
        Gamestate.pop()
    end
end


