highscores = {}


record = {}
record.id = nil
record.score = nil
record.smashes = nil
record.playtime = nil
record.round = nil
record.date = nil



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
