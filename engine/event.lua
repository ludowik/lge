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
end

function contains(mouse)
    local object = parameter:contains(mouse.position)
    if object then return object end

    for i=#process,1,-1 do
        local sketch = process[i]
        local object = sketch:contains(mouse.position)
        if object then return object end
    end
    
end

local currentObject = nil
function love.mousepressed(x, y, button, istouch, presses)
    currentObject = contains({
        position = vec2(x, y)
    })

    if currentObject then
        currentObject:mousepressed({
            position = vec2(x, y)
        })
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if currentObject then
        currentObject:mousemoved({
            position = vec2(x, y)
        })
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if currentObject then
        currentObject:mousereleased({
            position = vec2(x, y)
        })
    end
    currentObject = nil
end
