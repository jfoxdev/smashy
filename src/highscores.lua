highscores = {}

record = {}
record.id = nil
record.score = nil
record.smashes = nil
record.playtime = nil
record.round = nil
record.date = nil

credits = {}

normal_font = love.graphics.newFont(32)

function highscores:enter()
    love.graphics.setBackgroundColor(0,0,0)	
    love.graphics.setColor(255,255,255)
    highscores.background = love.graphics.newImage("data/highscores.png")	
    button_spawn(890,700, "Back", "back")

	love.mouse.setVisible( true )

end

function highscores:leave()
	clear_all_buttons()
	love.mouse.setVisible(false)
	
end


function highscores:update(dt)
	button_hover(love.mouse.getX(), love.mouse.getY())
    button_update()	   

end

function highscores:draw()	
	love.graphics.setColor(255,255,255)
    love.graphics.draw(highscores.background, 0, 0)	
    
    button_draw_id("back")
	
    show_records(50, 150)

end

function highscores:keypressed(key)
    if key == 'return' or
       key == 'escape' then
        Gamestate.switch(titlescreen)
    end
end

function highscores:mousereleased(x,y)
	button_click(x, y)
end




function show_records(x,y)
	love.graphics.setFont(normal_font)
	love.graphics.setColor(240,255,0)

	for i, score, timestamp in highscore() do	
		love.graphics.setColor(240,255,0)		
		love.graphics.print(i..")", x, y + (normal_font:getHeight() * i))		
		love.graphics.setColor(200,255,200)
		love.graphics.print(timestamp, x+150, y + (normal_font:getHeight() * i))	
		love.graphics.setColor(240,255,0)		
		love.graphics.print(score, x + 600, y + (normal_font:getHeight() * i))
	end

end



