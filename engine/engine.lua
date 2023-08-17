function love.load()
    classSetup()
    classUnitTesting()

    components = Node()
    components:add(timeManager)
    components:add(tweenManager)
    components:add(processManager)

    globalManager = GlobalManager()

    reload()
end

GlobalManager = class() : extends(Rect, MouseEvent, KeyboardEvent)

function GlobalManager:init()
    Rect.init(self, 0, 0.8* H, W, 0.2 * H)
    MouseEvent.init(self)
end

function GlobalManager:mousereleased(mouse)
    local sketch = processManager:current()

    if mouse.position.x < .5 * W then
        processManager:previous()
    else
        processManager:next()
    end
end

function contains(mouse)
    local process = processManager:current()
    
    if not love.filesystem.isFused() then
        local object = globalManager:contains(mouse.position)
        if object then return object end

        local object = process.parameter:contains(mouse.position)
        if object then return object end
    end
    
    local object = process:contains(mouse.position)
    if object then return object end
end

function love.update(dt)
    components:update(dt)

    updateSettings()
end

function love.draw()    
    local process = processManager:current()

    resetMatrix()
    resetStyle()
    process:drawSketch()
    
    if not love.filesystem.isFused() then
        resetMatrix()
        resetStyle()
        process.parameter:draw()
    end
end

function reload(reload)
    processManager:clear()
    load(reload)
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
