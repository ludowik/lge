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

function contains(mouse)
    local object = parameter:contains(mouse.position)
    if object then return object end

    local process = {process:current()}
    for _,sketch in ipairs(process, true) do
        local object = sketch:contains(mouse.position)
        if object then return object end
    end
    
end

local currentObject = nil
function love.mousepressed(x, y, button, istouch, presses)
    currentObject = contains({
        position = vec2(x-X, y-Y)
    })

    if currentObject then
        currentObject:mousepressed({
            position = vec2(x-X, y-Y)
        })
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if currentObject then
        currentObject:mousemoved({
            position = vec2(x-X, y-Y)
        })
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if currentObject then
        currentObject:mousereleased({
            position = vec2(x-X, y-Y)
        })
    end
    currentObject = nil
end
