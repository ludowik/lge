class().setup = function ()
    love.keyboard.setKeyRepeat(true)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'r' then
        reload()
    end
    if key == 'z' then
        makezip()
    end
    if key == 'escape' then
        quit()
    end
    if key == 'left' then
        process:previous()
    end
    if key == 'right' then
        process:next()
    end
end

local currentObject = nil

local function mousepressed(x, y, button, presses)
    mouse:pressed(x, y)

    currentObject = contains(mouse)
    if currentObject then
        currentObject:mousepressed(mouse)
    end
end

if getOS() == 'ios' then
    function love.touchpressed(id, x, y, dx, dy, pressure)
        mousepressed(x, y, id, 1)
    end
else
    function love.mousepressed(x, y, button, istouch, presses)
        mousepressed(x, y, button, presses)
    end
end

local function mousemoved(x, y, button)
    if currentObject then
        mouse:moved(x, y)
        currentObject:mousemoved(mouse)
    end
end

if getOS() == 'ios' then
    function love.touchmoved(id, x, y, dx, dy, pressure)
        mousemoved(x, y, 1)
    end
else
    function love.mousemoved(x, y, dx, dy, istouch)
        mousemoved(x, y, 1)
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
    function love.touchreleased(id, x, y, dx, dy, pressure)
        mousereleased(x, y, id, 1)
    end
else
    function love.mousereleased(x, y, button, istouch, presses)
        mousereleased(x, y, button, presses)
    end
end
