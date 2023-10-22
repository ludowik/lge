Engine = class()

function Engine.setup()
    engine = Engine()
end

function Engine.load()
    classSetup()
    classUnitTesting()

    engine.components = Node()
    engine.components:add(timeManager)
    engine.components:add(eventManager)
    engine.components:add(processManager)

    resetMatrix()
    resetStyle()    

    engine.reload()
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

    mouse:update(dt)

    -- TODEL
    --updateSettings()
end

local previousCanvas
function setContext(fb)
    if fb == nil then return resetContext() end
    assert(fb and fb.canvas)
    
    previousCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(fb.canvas)
    pushMatrix()
end

function resetContext(fb)
    popMatrix()
    love.graphics.setCanvas(previousCanvas)
end

function render2context(context, f)
    assert(context)

    setContext(context)
    love.graphics.origin()

    f()
    
    resetContext()
end

function noLoop()
    local process = processManager:current()
    -- TODO
    if not process then return end

    process.frames = 1
end

function loop()
    local process = processManager:current()
    -- TODO
    if not process then return end

    process.frames = nil
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
    do
        resetMatrix()
        resetStyle()
        process:drawSketch()
    end  
    
    resetMatrix()
    resetStyle()
    engine.parameter:draw()

    if not fused() then
        engine.navigation:draw(-X, -Y)
    end

    local fps = getFPS()
    if fps < 60 then
        fontName('arial')
        fontSize(18)
        local w, h = textSize(fps)
        textColor(colors.red)
        textMode(CENTER)
        text(fps, W-w/2-UI.innerMarge, -Y/2)
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
