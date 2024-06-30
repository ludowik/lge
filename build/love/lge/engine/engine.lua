Engine = class()

function Engine.setup()
    engine = Engine()
end

function Engine.load()
    classSetup()
    classUnitTesting()

    resetMatrix(true)
    resetStyle()

    engine.reload()

    instrument = Instrument()

    engine.components = Array()
    engine.components:add(mouse)
    engine.components:add(timeManager)
    engine.components:add(eventManager)
    engine.components:add(processManager)
    engine.components:add(instrument)
end

function Engine.initParameter()
    engine.parameter = Parameter('right')

    if fused() then
        engine.parameter:addUnfusedMenu()
    else
        engine.parameter:addMainMenu()
        engine.parameter:addNavigationMenu()
        engine.parameter:addCaptureMenu()

        engine.navigation = Parameter('left')
        engine.navigation:initControlBar()
    end

    engine.parameter:group('sketch', true)
end

function Engine.reload(reload)
    engine.initParameter()
    processManager:clear()
    return load(reload)
end

function Engine.quit()
    engine.components:release()
    quit()
end

function Engine.contains(mouse)
    local object = engine.parameter:contains(mouse.position)
    if object then return object end

    local object = not fused() and engine.navigation:contains(mouse.position)
    if object then return object end

    local sketch = processManager:current()
    local object = sketch:contains(mouse.position)
    if object then return object end
end

function Engine.update(dt)
    engine.components:update(dt)
end

function Engine.redraw()
    local sketch = processManager:current()
    if sketch.loopMode == 'none' then
        sketch.loopMode = 'redraw'
    end
end
redraw = Engine.redraw

function echo(txt)
    __echo = txt
    __echoElapsedTime = 3
end

function Engine.draw()
    love.graphics.reset()
    
    local sketch = processManager:current()
    sketch:drawSketch()

    resetMatrix(true)
    resetStyle()
    
    engine.parameter:draw(0, TOP)

    if instrument.active then
        instrument:draw()
    end

    if not fused() then
        engine.navigation:draw(0, 0)
    end
    
    local fps = getFPS()
    if fps < refreshRate * 0.95 then -- or fps > refreshRate * 1.05 then
        fontName('arial')
        fontSize(18)
        local w, h = textSize(fps)
        textColor(colors.red)
        textMode(CENTER)
        text(fps, W - w / 2 - UI.innerMarge, TOP / 2)
    end

    if __echo then        
        textMode(CORNER)
        fontSize(32)
        text(__echo..' '..W..'/'..H, 25, 25)

        __echoElapsedTime = __echoElapsedTime - timeManager.deltaTime
        if __echoElapsedTime <= 0 then
            __echo = nil
            __echoElapsedTime = nil
        end
    end
end

function toggleFused()
    setSetting('fused', not fused())
    engine.reload(true)
end

function fused()
    return getSetting('fused', false)
end

function getFPS()
    return love.timer.getFPS()
end

function restart()
    love.event.quit('restart')
end

function quit()
    love.event.quit()
end

function exit()
    local ffi = try_require 'ffi'
    if ffi then
        ffi.cdef 'void exit(int)'
        ffi.C.exit(0)
    end
end
