button = {}

tinytext = love.graphics.newFont(24)
medium = love.graphics.newFont(45)
massive = love.graphics.newFont(60)

color_off = { r = 200, g = 0, b = 0, a = 255 }
color_on = { r = 0, g = 200, b = 0, a = 255 }

function button_spawn(x, y, text, id)
	table.insert(button, {x = x, y = y, text = text, id = id, color = color_off})

end


function button_update(dt)
   
end

function button_draw()
	for i,v in ipairs(button) do
		
		love.graphics.setColor(100,100,100,200)
		love.graphics.rectangle("fill", v.x, v.y, medium:getWidth(v.text), medium:getHeight() )
		love.graphics.setColor(220,220,220,200)
		love.graphics.rectangle("line", v.x, v.y, medium:getWidth(v.text), medium:getHeight() )

		
		love.graphics.setColor(v.color.r, v.color.g, v.color.b, v.color.a)
		love.graphics.setFont(medium)
		love.graphics.print(v.text, v.x, v.y)
	end
end
function button_draw_id(id)
	for i,v in ipairs(button) do
		if v.id == id then
			love.graphics.setColor(100,100,100,200)
			love.graphics.rectangle("fill", v.x, v.y, medium:getWidth(v.text), medium:getHeight() )
			love.graphics.setColor(220,220,220,200)
			love.graphics.rectangle("line", v.x, v.y, medium:getWidth(v.text), medium:getHeight() )
			
			love.graphics.setColor(v.color.r, v.color.g, v.color.b, v.color.a)
			love.graphics.setFont(medium)
			love.graphics.print(v.text, v.x, v.y)
		end
	end
end




function button_click(x, y)
	for i,v in ipairs(button) do
		if x > v.x and
		x < v.x + medium:getWidth(v.text) and
		y > v.y and
		y < v.y + medium:getHeight() then
		
			if v.id == "new" then 
				Gamestate.switch(level)
			end
			if v.id == "quit" then 
				Gamestate.switch(credits)
			end			
			
			if v.id == "next" then 
				Gamestate.switch(level)
			end
			
			if v.id == "title" then 
				Gamestate.switch(titlescreen)
			end
			
			if v.id == "retry" then 
				Gamestate.switch(level)
			end
			
		end
	
	
	end 
end

function button_hover(x, y)
	for i,v in ipairs(button) do
		if x > v.x and
		x < v.x + medium:getWidth(v.text) and
		y > v.y and
		y < v.y + medium:getHeight() then 
			v.color = color_on
		
		else 
			v.color = color_off 
		
		end	
	
	
	end 
end
