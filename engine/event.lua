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

local globalManager = class()
function globalManager:mousepressed(mouse)
end
function globalManager:mousemoved(mouse)
end
function globalManager:mousereleased(mouse)
    if mouse.position.x < .5 * W then
        process:previous()
    else
        process:next()
    end
end

mouse = {}

function love.mousepressed(x, y, button, istouch, presses)
    mouse.position = vec2(x-X, y-Y)
    mouse.startPosition = mouse.position
    mouse.previousPosition = mouse.position

    if mouse.position.y > .8 * H then   
        currentObject = globalManager
    else
        currentObject = contains(mouse)
    end

    if currentObject then
        currentObject:mousepressed(mouse)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if currentObject then
        mouse.previousPosition = mouse.position
        mouse.position = vec2(x-X, y-Y)
        mouse.move = mouse.position - mouse.startPosition

        currentObject:mousemoved(mouse)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if currentObject then
        mouse.previousPosition = mouse.position
        mouse.position = vec2(x-X, y-Y)
        mouse.endPosition = mouse.position
        mouse.move = mouse.endPosition - mouse.startPosition        
        
        currentObject:mousereleased(mouse)
    end
    currentObject = nil
end
