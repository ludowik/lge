function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			if love.draw() then 
    			love.graphics.present()
            end
		end

		if love.timer then love.timer.sleep(0.001) end
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
        eventManager:mousereleased(button, x, y)
    end
end

function love.keypressed(key, scancode, isrepeat)
    eventManager:keypressed(key, scancode, isrepeat)
end
