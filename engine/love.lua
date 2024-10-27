function love.runProc()
	love.load(love.arg.parseGameArguments(arg), arg)

	-- We don't want the first frame's dt to include time taken by love.load.
	love.timer.step()

	local dt = 0

	-- Main loop time
	local mainLoop = function ()
		-- Process events
		love.event.pump()
		for name, a,b,c,d,e,f in love.event.poll() do
			if name == 'quit' then
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

	return function (...)
		local args = {...}
		local status, result = xpcall(
			function ()
				return mainLoop(unpack(args))
			end,
            function (msg)
				error(msg)
            end)
		return result
	end
end

function love.load(arg, unfilteredArg)
    Engine.load()
end

function love.update(dt)
    Engine.update(dt)
end

function love.draw()
    return Engine.draw()
end

function love.filedropped(file)
    local filename = file:getFilename()
	local ext = filename:match("%.%w+$")
	if ext == ".love" then
        file:open('r')
        love.filesystem.write('lge.love', file:read())
        restart()
    end
end

function scaleMouseProperties(...)
    local values = Array()
    for i,v in ipairs{...} do
        values:add(v/SCALE)
    end
    return values:unpack()
end

if getOS() == 'ios' then
    local touches = {}

    function love.touchpressed(id, x, y, dx, dy, pressure)
        x, y = scaleMouseProperties(x, y)
        touches[id] = {
            presses = 1,
            moved = false,
            mouse = Mouse()
        }
        mouse = touches[id].mouse
        eventManager:mousepressed(id, x, y, 0)
    end

    function love.touchmoved(id, x, y, dx, dy, pressure)
        x, y = scaleMouseProperties(x, y)
        touches[id].moved = true
        mouse = touches[id].mouse
        eventManager:mousemoved(id, x, y)
    end

    function love.touchreleased(id, x, y, dx, dy, pressure)
        x, y = scaleMouseProperties(x, y)
        mouse = touches[id].mouse
        eventManager:mousereleased(id, x, y, touches[id].presses)
        touches[id] = nil
    end

    function love.displayrotated(index, orientation)
        setDeviceOrientation(orientation:startWith('landscape') and LANDSCAPE or PORTRAIT)
    end

else
    class().setup = function ()
        mouse = mouse or Mouse()
    end

    function love.mousepressed(x, y, button, istouch, presses)
        x, y = scaleMouseProperties(x, y)
        eventManager:mousepressed(button, x, y, presses)
    end

    function love.mousemoved(x, y, dx, dy, istouch)
        x, y = scaleMouseProperties(x, y)
        eventManager:mousemoved(mouse.id, x, y)
    end

    function love.mousereleased(x, y, button, istouch, presses)
        x, y = scaleMouseProperties(x, y)
        eventManager:mousereleased(button, x, y, presses)
    end

	function love.wheelmoved(dx, dy)
        dx, dy = scaleMouseProperties(dx, dy)
		eventManager:wheelmoved(dx, dy)
	end
end

function love.textinput(text)
    eventManager:textinput(text)
end

function love.keypressed(key, scancode, isrepeat)
    eventManager:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    eventManager:keyreleased(key, scancode)
end
