function love.run()
	love.load(love.arg.parseGameArguments(arg), arg)

	-- We don't want the first frame's dt to include time taken by love.load.
	love.timer.step()

	local dt = 0

	-- Main loop time
	return function ()
		-- Process events
		love.event.pump()
		for name, a,b,c,d,e,f in love.event.poll() do
			if name == "quit" then
				if not love.quit or not love.quit() then
					return a or 0
				end
			end
			love.handlers[name](a,b,c,d,e,f)
		end

		-- Update dt, as we'll be passing it to update
		dt = love.timer.step()

		-- Call update
		love.update(dt)

		-- Call draw
		if love.graphics.isActive() then
			love.graphics.origin()
			local needPresent = love.draw()
			if needPresent then 
    			love.graphics.present()
            end
		end

		love.timer.sleep(0.001)
	end
end

function try(f, catch)
	local ok, result = pcall(f)
	if not ok then
		catch()
		return
	end
	return result
end

function love.load()
    return try(function ()
		return Engine.load()
	end, function ()
		setSettings('sketch', nil)
		exit()
	end)
end

function love.update(dt)
    return try(function ()
		return Engine.update(dt)
	end, function ()
		setSettings('sketch', nil)
		exit()
	end)
end

function love.draw()
    return try(function ()
		return Engine.draw()
	end, function ()
		setSettings('sketch', nil)
		exit()
	end)
end

if getOS() == 'ios' then
    function love.touchpressed(id, x, y, dx, dy, pressure)
        eventManager:mousepressed(id, x, y)
    end

    function love.touchmoved(id, x, y, dx, dy, pressure)
        eventManager:mousemoved(id, x, y)
    end

    function love.touchreleased(id, x, y, dx, dy, pressure)
        eventManager:mousereleased(id, x, y)
    end

else
    function love.mousepressed(x, y, button, istouch, presses)
        eventManager:mousepressed(button, x, y)
    end

    function love.mousemoved(x, y, dx, dy, istouch)
        eventManager:mousemoved(1, x, y)
    end

    function love.mousereleased(x, y, button, istouch, presses)
        eventManager:mousereleased(button, x, y)
    end
end

function love.keypressed(key, scancode, isrepeat)
    eventManager:keypressed(key, scancode, isrepeat)
end
