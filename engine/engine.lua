function love.load()
    classSetup()
    classUnitTesting()

    components = Node()
    components:add(TimeManager)
    components:add(process)

    globalManager = GlobalManager()

    reload()
end

GlobalManager = class() : extends(Rect, MouseEvent)

function GlobalManager:init()
    Rect.init(self, 0, 0.8* H, W, 0.2 * H)
    MouseEvent.init(self)
end

function GlobalManager:mousereleased(mouse)
    if mouse.position.x < .5 * W then
        process:previous()
    else
        process:next()
    end
end

function contains(mouse)
    local process = process:current()
    
    local object = globalManager:contains(mouse.position)
    if object then return object end

    local object = process.parameter:contains(mouse.position)
    if object then return object end

    local object = process:contains(mouse.position)
    if object then return object end
end

function love.update(dt)
    components:update(dt)

    updateSettings()
end

function love.draw()    
    local process = process:current()
    resetMatrix()
    resetStyle()
    process:drawSketch()
    
    resetMatrix()
    resetStyle()
    process.parameter:draw()   
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
