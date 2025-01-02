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

    saveSketchesList()
end

function Engine.initParameter()
    engine.parameter = Parameter('right')

    engine.parameter:action('update from local', function ()
        updateScripts(false)
    end)

    if not fused() then
        engine.parameter:addMainMenu()
        engine.parameter:addNavigationMenu()
        engine.parameter:addScreenMenu()
        engine.parameter:addCaptureMenu()
    end

    engine.navigation = Parameter('left')
    engine.navigation:initControlBar()

    engine.parameter:group('sketch', true)
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
    local object = engine.parameter:contains(mouse.position)
    if object then return object end

    if engine.parameter.currentMenu and engine.parameter.currentMenu.label == 'navigation' then                
        local object = engine.navigation:contains(mouse.position)
        if object then return object end
    end

    local sketch = processManager:current()
    local object = sketch:contains(mouse.position)
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
    
end

function Engine.draw()
    love.graphics.reset()
    
    local sketch = processManager:current()
    sketch:drawSketch()

    resetMatrix(true)
    resetStyle()

    scale(SCALE)
    
    engine.navigation:draw(0, 0)

    if fused() then
        return
    end

    engine.parameter:draw(0, TOP)

    if instrument.active then
        instrument:draw()
    end

    local fps = getFPS()
    if fps < refreshRate * 0.95 then -- or fps > refreshRate * 1.05 then
        fontName(DEFAULT_FONT_NAME)
        fontSize(18)
        local w, h = textSize(fps)
        textColor(colors.red)
        textMode(CORNER)
        text(fps, LEFT, TOP)
    end

    if __echo then
        echoUpdate(env.deltaTime)

        fontName(DEFAULT_FONT_NAME)
        fontSize(32)

        textColor((getBackgroundColor() or colors.black):contrast())
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
end

function Engine.redraw()
    local sketch = processManager:current()
    if sketch.loopMode == 'none' then
        sketch.loopMode = 'redraw'
    end
end
redraw = Engine.redraw

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
