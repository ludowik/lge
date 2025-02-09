Engine = class()

function Engine.load()
    engine = Engine()

    classSetup()
    classUnitTesting()

    -- resetMatrix(true)
    -- resetStyle()

    engine.reload()

    instrument = Instrument()

    engine.components = Array()
    engine.components:add(mouse)
    engine.components:add(timeManager)
    engine.components:add(eventManager)
    engine.components:add(processManager)
    engine.components:add(instrument)

    saveSketchesList()
end

function Engine.initParameter()
    engine.parameter = Parameter('left')
    engine.parameter.visible = false

    if not fused() then
        engine.parameter:action('sketches', function() processManager:setSketch('sketches', false) end)
        engine.parameter:addMainMenu()
        engine.parameter:addNavigationMenu()
        engine.parameter:addScreenMenu()
        engine.parameter:addCaptureMenu()
    end

    engine.navigation = Parameter('left')
    engine.navigation:initControlBar()
end

function Engine.reload(reload)
    engine.initParameter()
    processManager:clear()
    return load(reload)
end

function Engine.quit()
    local sketch = processManager:current()
    if sketch and sketch.release then sketch:release() end
    
    engine.components:release()
    quit()
end

function Engine.contains(mouse)
    local sketch = processManager:current()
    
    local object = engine.parameter:contains(mouse.position)
    if object then return object end

    object = sketch.parameter:contains(mouse.position)
    if object then return object end

    --if engine.parameter.currentMenu and engine.parameter.currentMenu.label == 'navigation' then                
        object = engine.navigation:contains(mouse.position)
        if object then return object end
    --end

    object = sketch.bar:contains(mouse.position)
    if object then return object end

    object = sketch:contains(mouse.position)
    if object then return object end
end

function Engine.update(dt)
    engine.components:update(dt)
end

-- TODO : manage by class
local __echo = Array()
local __echoElapsedTime = 0

function echoClear()
    __echo = Array()
    __echoElapsedTime = 0
end

function echo(...)
    __echo = __echo or Array()
    local line = Array.concat({...}, ', ')
    if #__echo > 0 and __echo[#__echo].line == line then
        __echo[#__echo].count = __echo[#__echo].count + 1
    else
        __echo:add({line=line, count=1})
    end
    __echoElapsedTime = 3
end

function echoUpdate(dt)
    __echoElapsedTime = __echoElapsedTime - dt
    if __echoElapsedTime <= 0 then
        echoClear()
    end
end

function echoDraw()
    echoUpdate(env.deltaTime)

    fontName(DEFAULT_FONT_NAME)
    fontSize(DEFAULT_FONT_SIZE * 2)

    textColor(getBackgroundColor():contrast())
    textMode(CORNER)

    local txt = ''
    for _,line in ipairs(__echo) do
        txt = txt..line.line
        if line.count > 1 then
            txt = txt..' ('..line.count..')'
        end
        txt = txt..NL
    end
    text(txt, 25, 25)
end

function Engine.draw()
    resetMatrix(true)
    resetStyle()

    local sketch = processManager:current()
    sketch:drawSketch()

    resetMatrix(true)
    resetStyle()

    scale(SCALE)
    
    engine.navigation:draw(0, 0)

    if fused() then
        return
    end

    sketch.parameter:draw(0, TOP)
    engine.parameter:draw(LEFT, TOP)

    if instrument.active then
        instrument:draw()
    end

    local showFPS = env.sketch.parameter.visible
    
    local fps = getFPS()
    if showFPS or fps < refreshRate * 0.95 then
        fontName(DEFAULT_FONT_NAME)
        fontSize(SMALL_FONT_SIZE)
        
        textColor(colors.red)
        textMode(CORNER)
        text(fps..' fps / '..getMemoryInfo(), W-LEFT-SMALL_FONT_SIZE, H-2*SMALL_FONT_SIZE, nil, 'right')
    end

    if __echo then
        echoDraw()
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
    if ffi then
        ffi.cdef 'void exit(int)'
        ffi.C.exit(0)
    end
end
