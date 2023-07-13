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

function love.mousepressed(x, y, button, istouch, presses)
    mouse:pressed(x, y)

    currentObject = contains(mouse)
    if currentObject then
        currentObject:mousepressed(mouse)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if currentObject then
        mouse:moved(x, y)
        currentObject:mousemoved(mouse)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if currentObject then
        mouse:released(x, y)
        currentObject:mousereleased(mouse)
    end
    currentObject = nil
end
