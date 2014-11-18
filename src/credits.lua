credits = {}


function credits:enter()
    love.graphics.setColor(0,0,0)
    credits.background = love.graphics.newImage("data/credits.png")
	love.mouse.setVisible( false )
end

function credits:leave()

end


function credits:update(dt)

end

function credits:draw()	
	love.graphics.setColor(255,255,255)
    love.graphics.draw(credits.background, 0, 0)
end

function credits:keypressed(key)
	love.event.quit()
end
function credits:mousepressed(x,y)
	love.event.quit()
end
