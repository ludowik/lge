Engine = class()

function Engine.setup()
    engine = Engine()
end

function love.load()
    Engine.load()
end

function Engine.load()
    classSetup()
    classUnitTesting()

    engine.components = Node()
    engine.components:add(timeManager)
    engine.components:add(tweenManager)
    engine.components:add(processManager)
    engine.components:add(eventManager)

    engine.parameter = Parameter()
    engine.parameter:initMenu()

    reload()
end

function contains(mouse)
    local process = processManager:current()
    
    local object = engine.parameter:contains(mouse.position)
    if object then return object end

    local object = process:contains(mouse.position)
    if object then return object end
end

function love.update(dt)
    engine.components:update(dt)
    updateSettings()
end

function love.draw()  
    love.graphics.reset()

    local process = processManager:current()

    resetMatrix()
    resetStyle()
    process:drawSketch()
    
    resetMatrix()
    resetStyle()
    engine.parameter:draw()
end

function toggleFused()
    setSettings('fused', not getSettings('fused'))

    if fused() then
        engine.parameter:openGroup(engine.parameter.currentGroup)
    else
        engine.parameter:closeGroup(engine.parameter.currentGroup)
    end
end

function fused()
    return getSettings('fused')
end

function reload(reload)
    processManager:clear()
    return load(reload)
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
    local ffi = require 'ffi'
    if ffi then
        ffi.cdef 'void exit(int)'
        ffi.C.exit(0)
    end
end
