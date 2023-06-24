class().setup = function ()
    love.keyboard.setKeyRepeat(true)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'r' then
        reload()
    end
    if key == 'escape' then
        quit()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    parameter:mousepressed({
        position = vec2(x, y)
    })
end

function love.mousereleased(x, y, button, istouch, presses)
    parameter:mousereleased({
        position = vec2(x, y)
    })
end
