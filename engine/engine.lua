function love.load()
    classSetup()
    classUnitTesting()

    components = Node()
    components:add(TimeManager)
    components:add(process)

    reload()
end


function contains(mouse)
    local process = process:current()
    
    local object = process.parameter:contains(mouse.position)
    if object then return object end

    local object = process:contains(mouse.position)
    if object then return object end
end

function love.update(dt)
    components:update(dt)
end

function love.draw()
    love.graphics.setScissor()
    love.graphics.discard()
    
    background(Color(251))

    local process = process:current()
    resetMatrix()
    resetStyle()
    process:drawSketch()
    
    resetMatrix()
    resetStyle()
    process.parameter:draw()   
end

function restart()
    love.event.quit('restart')
end

function reload()
    process:clear()
    load()
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
