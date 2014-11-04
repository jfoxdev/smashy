require "button"

losing = {}

function losing:enter()
    love.graphics.setColor(0,0,0)
    losing.background = love.graphics.newImage("data/losing.png")

	button_spawn(200,400, "Re-Smashy!", "retry")
	
	love.mouse.setVisible(true)
end

function losing:resume()

end

function losing:leave()

end


function losing:update(dt)
	
	button_hover(love.mouse.getX(), love.mouse.getY())
    button_update()

end

function losing:draw()
	love.graphics.setColor(255,255,255,255)
    love.graphics.draw(losing.background, 0, 0)
 	
    button_draw_id("retry")
    button_draw_id("title")
end

function losing:keyreleased(key)
    if key == 'return' then
        Gamestate.pop()
    end
    if key == 'escape' then
        Gamestate.switch(credits)
    end
end

function losing:mousepressed(x,y)
	button_click(x, y)
end
