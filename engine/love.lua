function love.runProc()
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
			love.draw()
			love.graphics.present()
		end

		love.timer.sleep(0.001)
	end
end

function love.load()
    Engine.load()	
end

function love.update(dt)
    Engine.update(dt)
end

function love.draw()
    return Engine.draw()
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
        if presses > 1 then
            eventManager:click(presses)
        else
            eventManager:mousereleased(button, x, y)
        end
    end

	function love.wheelmoved(x, y)
		eventManager:wheelmoved(x, y)
	end
end

function love.keypressed(key, scancode, isrepeat)
    eventManager:keypressed(key, scancode, isrepeat)
end
