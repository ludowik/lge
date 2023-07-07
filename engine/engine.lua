function love.load()
    classSetup()
    classUnitTesting()

    components = Node()
    components:add(TimeManager)
    components:add(parameter)
    components:add(process)

    reload()
end


function contains(mouse)
    local object = parameter:contains(mouse.position)
    if object then return object end

    local process = {process:current()}
    for _,sketch in ipairs(process, true) do
        local object = sketch:contains(mouse.position)
        if object then return object end
    end 
end

function love.update(dt)
    components:update(dt)
    --process:update(dt)
    
    -- local process = {process:current()}
    -- for _, sketch in ipairs(process) do
    --     sketch:updateSketch(dt)
    -- end
    --parameter:update(dt)
end

function love.draw()
    background(Color(251))

    local process = {process:current()}
    for _, sketch in ipairs(process) do
        resetStyle()
        sketch:drawSketch()
    end
    
    resetStyle()
    parameter:draw()   
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
