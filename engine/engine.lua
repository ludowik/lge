function love.load()
    classSetup()
    classUnitTesting()

    components = Node()
    components:add(TimeManager)
    components:add(process)

    globalManager = GlobalManager()

    reload()

    timeBeforeHideParameter = 5
end

GlobalManager = class() : extends(Rect, MouseEvent, KeyboardEvent)

function GlobalManager:init()
    Rect.init(self, 0, 0.8* H, W, 0.2 * H)
    MouseEvent.init(self)
end

function GlobalManager:mousereleased(mouse)
    local sketch = process:current()

    if timeBeforeHideParameter < 0 then
        timeBeforeHideParameter = 5
        return
    end

    if mouse.position.x < .5 * W then
        process:previous()
    else
        process:next()
    end
end

function contains(mouse)
    local process = process:current()
    
    if not love.filesystem.isFused() then
        local object = globalManager:contains(mouse.position)
        if object then return object end
    
        if timeBeforeHideParameter < 0 then
            local object = process.parameter:contains(mouse.position)
            if object then return object end
        end
    end
    
    local object = process:contains(mouse.position)
    if object then return object end
end

function love.update(dt)
    components:update(dt)

    updateSettings()

    timeBeforeHideParameter = timeBeforeHideParameter - dt
end

function love.draw()    
    local process = process:current()
    resetMatrix()
    resetStyle()
    process:drawSketch()
    
    if (not love.filesystem.isFused() and 
        timeBeforeHideParameter > 0)
    then
        resetMatrix()
        resetStyle()
        process.parameter:draw()
    end
end

function reload()
    process:clear()
    load()
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
