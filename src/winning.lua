require "button"

winning = {}

function winning:enter()

    love.graphics.setColor(0,0,0)
    winning.background = love.graphics.newImage("data/winning.png")

	winning.perfect = "U Haz Perfect Smashy!"
	winning.score_text = "Score: "
	winning.smash_text = "Smashes: "
	winning.combo_text = "Combos Broken: "

	button_spawn(200,400, "Next Smashy!", "next")
	button_spawn(700,400, "Quit", "title")
	
	love.mouse.setVisible(true)
end

function winning:resume()

end

function winning:leave()
	
end


function winning:update(dt)
	
	button_hover(love.mouse.getX(), love.mouse.getY())
    button_update()

end

function winning:draw()
	love.graphics.setColor(255,255,255,255)
    love.graphics.draw(winning.background, 0, 0)
 		
 	love.graphics.setColor(255,255,50,255)
	love.graphics.setFont(massive)
	if game.combo_breaks == 0 then
		local perfpos = 1024/2 - massive:getWidth(winning.perfect)/2			
		love.graphics.rectangle("line", perfpos, 270, massive:getWidth(winning.perfect), massive:getHeight() )
		love.graphics.print(winning.perfect,perfpos,270)
	end
	
	love.graphics.setFont(medium)
	love.graphics.print(winning.score_text ..game.score ,50,600)
	love.graphics.print(winning.smash_text ..game.smashes ,50,660)
	love.graphics.print(winning.combo_text ..game.combo_breaks ,500,660)
		   
    button_draw_id("next")
    button_draw_id("title")
    
end

function winning:keyreleased(key)
    if key == 'return' then
        Gamestate.switch(level)
    end
    if key == 'escape' then
        Gamestate.switch(titlescreen)
    end
end

function winning:mousepressed(x,y)
	button_click(x, y)
end
