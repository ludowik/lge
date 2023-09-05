function love.load()
    Engine.load()
end

function love.update(dt)
    Engine.update(dt)
end

function love.draw()  
    Engine.draw()
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
