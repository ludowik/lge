class().setup = function ()
    love.keyboard.setKeyRepeat(true)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'r' then
        reload()
    elseif key == 'z' then
        makezip()
    elseif key == 'escape' then
        quit()
    elseif key == 'pageup' then
        processManager:previous()
    elseif key == 'pagedown' then
        processManager:next()
    end

    processManager:current():keypressed(key, scancode, isrepeat)
end

local currentObject = nil

local function mousepressed(x, y, button, presses)
    mouse:pressed(x, y)

    currentObject = contains(mouse)
    if currentObject then
        currentObject:mousepressed(mouse)
    end
end

local function mousemoved(x, y, button)
    if currentObject then
        mouse:moved(x, y)
        currentObject:mousemoved(mouse)
    end
end

local function mousereleased(x, y, button, presses)
    if currentObject then
        mouse:released(x, y)
        currentObject:mousereleased(mouse)
    end
    currentObject = nil
end

if getOS() == 'ios' then
    function love.touchpressed(id, x, y, dx, dy, pressure)
        mousepressed(x, y, id, 1)
    end

    function love.touchmoved(id, x, y, dx, dy, pressure)
        mousemoved(x, y, 1)
    end

    function love.touchreleased(id, x, y, dx, dy, pressure)
        mousereleased(x, y, id, 1)
    end

else
    function love.mousepressed(x, y, button, istouch, presses)
        mousepressed(x, y, button, presses)
    end

    function love.mousemoved(x, y, dx, dy, istouch)
        mousemoved(x, y, 1)
    end

    function love.mousereleased(x, y, button, istouch, presses)
        mousereleased(x, y, button, presses)
    end
end
