highscores = {}


record = {}
record.id = nil
record.score = nil
record.smashes = nil
record.playtime = nil
record.round = nil
record.date = nil


credits = {}


function highscores:enter()
    love.graphics.setColor(0,0,0)
    credits.background = love.graphics.newImage("data/highscores.png")	
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
    love.graphics.draw(credits.background, 0, 0)	
    
    button_draw_id("back")

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
	--open data/highscores
	local file = love.filesystem.newFile("data/highscores")
	file:open("r")
	data = file:read()
	-- read all into array
	for line in love.filesystem.lines("data/highscores") do
		table.insert(highscores, line)
	end
	-- print records to screen at x,y
	
	--close file
	file:close()
end


function save_record(score, smashes, playtime, round)
	--open data/highscores
	local file = love.filesystem.newFile("data/highscores")
	file:open("rw")
	data = file:read()
	-- read all into array
	for line in love.filesystem.lines("data/highscores") do
		table.insert(highscores, line)
	end
	-- insert score
	
	
	
	-- keep top 10 scores
	
	-- write file
	--for i = 0, #highscores do
	--	f:write()
	--end	
	--close file
	file:close()
end
