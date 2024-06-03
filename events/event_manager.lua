EventManager = class() : extends(MouseEvent, KeyboardEvent)

function EventManager.setup()
    eventManager = EventManager()
    love.keyboard.setKeyRepeat(true)
end

function EventManager:init()
    self.currentObject = nil
end

function EventManager:mousepressed(id, x, y, presses)
    mouse:pressed(id, x, y, 0)

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
    mouse:released(id, x, y, 0)
    
    if eventManager.currentObject then
        if mouse.move:len() <= 1 then -- and mouse.elapsedTime < 0.15
            mouse.presses = 1
            if eventManager.currentObject:click(mouse) then
                eventManager.currentObject = nil
                return
            end
        end
        
        eventManager.currentObject:mousereleased(mouse)
        eventManager.currentObject = nil
    end
end

function EventManager:wheelmoved(dx, dy)
    if _G.env.sketch.wheelmoved then
        _G.env.sketch:wheelmoved(dx, dy)
    end
end

function EventManager:keypressed(key, scancode, isrepeat)
    local sketch = processManager:current()
    if sketch.keypressed then
        sketch:keypressed(key, scancode, isrepeat)
    end
    
    if key == 'escape' then
        Engine.quit()

    elseif getOS() == 'osx' and love.keyboard.isDown('lgui') or love.keyboard.isDown('lctrl')  then
        if key == 'r' then
            engine.reload(true)

        elseif key == 'o' then
            if deviceOrientation == PORTRAIT then
                deviceOrientation = LANDSCAPE
            else
                deviceOrientation = PORTRAIT
            end
            setSetting('deviceOrientation', deviceOrientation)
            rotateScreen()

        elseif key == '^' then
            if deviceScreenRatio == screenRatios.ipad then
                deviceScreenRatio = screenRatios.iphone
            else
                deviceScreenRatio = screenRatios.ipad
            end
            setSetting('deviceScreenRatio', deviceScreenRatio)
            rotateScreen()

        elseif key == 't' then
            env.__autotest = not env.__autotest
            love.window.setVSync(env.__autotest and 0 or 1)
        
        elseif key == 'i' then
            processManager:setSketch('info')

        elseif key == 'p' then
            instrument:toggleState()

        elseif key == 's' then
            openSketches()

        elseif key == 'l' or key == 'kpenter' then
            processManager:loopProcesses()
        
        elseif key == 'f' then
            toggleFused()

        elseif key == 'w' then
            env.__wireframe = not env.__wireframe
        
        elseif key == 'up' then
            processManager:previous()
        
        elseif key == 'down' then
            processManager:next()
        end

    elseif key == 'f1' then
        local name = sketch.__className:replace('_', '+')
        openURL(('https://www.google.com/search?q=%s&lr=lang_en'):format(name))
        
    elseif key == 'pageup' then
        processManager:previous()
    
    elseif key == 'pagedown' then
        processManager:next()
    
    else
        self:search(key)
    end
end

function EventManager:keyreleased(key, scancode)
    local sketch = processManager:current()
    if sketch.keyreleased then
        sketch:keyreleased(key, scancode)
    end
end

local searchText = ''
local searchTime = 0

function EventManager:search(key)
    if time() - searchTime > 2 then
        searchText = ''
    end

    searchTime = time()
    
    if key == 'backspace' then
        searchText = searchText:sub(1, searchText:len()-1)
    else
        searchText = searchText..key
    end

    local sketches = processManager:findSketches(searchText)
    if #sketches == 1 then
        processManager:setCurrentSketch(sketches[1])
        searchText = ''
    end
end
