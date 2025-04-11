EventManager = class() : extends(MouseEvent, KeyboardEvent)

function EventManager.setup()
    eventManager = EventManager()
    
    love.keyboard.setKeyRepeat(true)
    love.keyboard.setTextInput(getOS() ~= 'ios')
end

function EventManager:init()
    self.currentObject = nil

    self.touches = Array()
    self.onEvents = Array()

    self:registerEvent('key', 'escape', Engine.quit)

    self:registerEvent('key', 'f1', function (sketch)
        local name = sketch.__className:replace('_', '+')
        openURL(('https://www.google.com/search?q=%s&lr=lang_en'):format(name))
    end)
end

function EventManager:update(dt)
    if eventManager.currentObjectTimer == nil then return end

    if not eventManager.currentObjectPressed then
        eventManager.currentObjectTimer = eventManager.currentObjectTimer - 1
        if eventManager.currentObjectTimer <= 0 then
            eventManager.currentObjectTimer = nil
            eventManager.currentObject = nil
        end
    end
end

function EventManager:mousepressed(id, x, y, presses)
    mouse:pressed(id, x, y, 0)

    self.touches[id] = Engine.contains(mouse)
    if self.touches[id] then
        self.touches[id]:mousepressed(mouse)
    else
        if env.__mousepressed then
            env.__mousepressed(mouse)
        end
    end
end

function EventManager:mousemoved(id, x, y)
    mouse:moved(id, x, y)
    
    if self.touches[id] then
        self.touches[id]:mousemoved(mouse)
    else
        if env.__mousemoved then
            env.__mousemoved(mouse)
        end
    end
end

function EventManager:mousereleased(id, x, y, presses)
    mouse:released(id, x, y, 0)
    
    if self.touches[id] then
        if mouse.move:len() <= 30 then -- and mouse.elapsedTime < 0.5 then
            mouse.presses = 1
            if self.touches[id]:click(mouse) then
                self.touches[id] = nil
                return
            end
        end
        
        self.touches[id]:mousereleased(mouse)
        self.touches[id] = nil
    else
        if env.__mousereleased then
            env.__mousereleased(mouse)
        end
    end
end

function EventManager:wheelmoved(dx, dy)
    local sketch = processManager:current()
    if sketch and sketch.wheelmoved then
        sketch:wheelmoved(dx, dy)
    end
end

function EventManager:textinput(text)
    self:search(text)
end

function EventManager:registerEvent(eventType, eventId, eventAction)
    self.onEvents[eventType] = self.onEvents[eventType] or {}
    self.onEvents[eventType][eventId] = eventAction
end

function EventManager:keypressed(key, scancode, isrepeat)
    local sketch = processManager:current()
    if sketch.keypressed then
        sketch:keypressed(key, scancode, isrepeat)
    end

    if self.onEvents.key[key] then
        self.onEvents.key[key](sketch)

    elseif love.keyboard.isDown('lgui') or love.keyboard.isDown('lctrl')  then
        if key == 'r' then
            engine.reload(true)

        elseif key == 'o' then
            Graphics.toggleDeviceOrientation()

        elseif key == 't' then
            env.__autotest = not env.__autotest
            Graphics.setVSync(env.__autotest and 0 or 1)
        
        elseif key == 'i' then
            processManager:setSketch('info', false)

        elseif key == 's' then
            ProcessManager.openSketches()

        elseif key == 'm' then
            if background == Graphics2d_bis.background then
                push2globals(Graphics2d)
            else
                push2globals(Graphics2d_bis)
            end

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

    elseif key == 'f5' then
        ProcessManager.openSketches()

    elseif key == 'f6' then
        Graphics.toggleLoop()

    elseif key == 'f11' then
        toggleFullScreen()        

    elseif key == 'f12' then
        instrument:toggleState()
    
    elseif key == 'pageup' then
        processManager:previous()
    
    elseif key == 'pagedown' then
        processManager:next()

    elseif key == 'backspace' then
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

function EventManager:search(text)
    if time() - searchTime > 2 then
        searchText = ''
    end

    searchTime = time()
    
    if text == 'backspace' then
        searchText = searchText:sub(1, searchText:len()-1)
    else
        searchText = searchText..text
    end

    echoClear()
    echo(searchText)

    local sketches = processManager:findSketches(searchText)
    if #sketches == 1 then
        processManager:setCurrentSketch(sketches[1])
        searchText = ''
    end
end
