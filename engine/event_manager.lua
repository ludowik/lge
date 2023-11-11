EventManager = class() : extends(MouseEvent, KeyboardEvent)

function EventManager.setup()
    eventManager = EventManager()
    love.keyboard.setKeyRepeat(true)
end

function EventManager:init()
    self.currentObject = nil
end

function EventManager:mousepressed(id, x, y, presses)
    mouse:pressed(id, x, y, presses)

    eventManager.currentObject = Engine.contains(mouse)
    if eventManager.currentObject then
        eventManager.currentObject:mousepressed(mouse)
    end
end

function EventManager:mousemoved(id, x, y)
    mouse:moved(id, x, y)
    
    if eventManager.currentObject then
        eventManager.currentObject:mousemoved(mouse)
    end
end

function EventManager:mousereleased(id, x, y, presses)
    mouse:released(id, x, y, presses)
    
    if eventManager.currentObject then
        eventManager.currentObject:mousereleased(mouse)
        eventManager.currentObject = nil
    end
end

function EventManager:click(id, x, y, presses)
    mouse:released(id, x, y, presses)

    if eventManager.currentObject then
        eventManager.currentObject:click(mouse)
        -- eventManager.currentObject = nil
    end
end

function EventManager:wheelmoved(x, y)
    if _G.env.sketch.wheelmoved then
        _G.env.sketch:wheelmoved(x, y)
    end
end

function EventManager:keypressed(key, scancode, isrepeat)
    if processManager:current() then
        processManager:current():keypressed(key, scancode, isrepeat)
    end

    if key == 'r' then
        engine.reload(true)

    elseif key == 't' then
        env.__autotest = not env.__autotest
        love.window.setVSync(env.__autotest and 0 or 1)
    
    elseif key == 'i' then
        processManager:setSketch('info')

    elseif key == 'p' then
        instrument.active = not instrument.active 

    elseif key == 's' then
        openSketches()

    elseif key == 'l' or key == 'kpenter' then
        processManager:loopProcesses()
    
    elseif key == 'f' then
        toggleFused()
    
    elseif key == 'escape' then
        Engine.quit()
    
    elseif key == 'pageup' then
        processManager:previous()
    
    elseif key == 'pagedown' then
        processManager:next()
    
    end
end
