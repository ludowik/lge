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

    local process = processManager:current()
    if process then
        local object = process:contains(mouse.position)
        if object then return object end
    end
end

function Engine.update(dt)
    engine.components:update(dt)
end

function redraw()
    local process = processManager:current()
    -- TODO
    if not process then return end

    if process.frames then
        process.frames = (process.frames or 0) + 1
    end
end

function Engine.draw()
    local process = processManager:current()
    -- TODO
    if not process then return end

    love.graphics.reset()
    process:drawSketch()

    resetMatrix(true)
    resetStyle()
    
    engine.parameter:draw(0, -Y)

    if instrument.active then
        instrument:draw()
    end

    if not fused() then
        engine.navigation:draw(-X, -Y)
    end
    
    local fps = getFPS()
    if fps < refreshRate * 0.95 then -- or fps > refreshRate * 1.05 then
        fontName('arial')
        fontSize(18)
        local w, h = textSize(fps)
        textColor(colors.red)
        textMode(CENTER)
        text(fps, W - w / 2 - UI.innerMarge, -Y / 2)
    end
end

function toggleFused()
    setSettings('fused', not fused())
    engine.reload(true)
end

function fused()
    return getSettings('fused', false)
end

function restart()
    love.event.quit('restart')
end

function quit()
    love.event.quit()
end

function getFPS()
    return love.timer.getFPS()
end

function exit()
    local ffi = try_require 'ffi'
    if ffi then
        ffi.cdef 'void exit(int)'
        ffi.C.exit(0)
    end
end
