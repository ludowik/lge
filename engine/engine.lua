function love.load()
    -- X, Y, W, H = love.window.getSafeArea()
    -- W, H = math.min(W, H), math.max(W, H)
    -- love.window.setMode(W, H)
    X, Y, W, H = love.window.getSafeArea()
    
    setupClass()
    unitTesting()
    push2globals(Graphics2d)

    font = love.graphics.newFont(25)

    load()
    
    parameter = Parameter()
    parameter:action('quit', quit)
    parameter:action('update', updateScripts)
    parameter:action('reload', reload)

    parameter:watch('fps', 'getFPS()')
    parameter:watch('fps', 'X..", "..Y')
end

function love.update(dt)
    for _, sketch in ipairs(process) do
        sketch:updateSketch(dt)
    end
    parameter:update(dt)
end

function love.draw()
    background(Color(251))
    
    for _, sketch in ipairs(process) do
        sketch:drawSketch()
    end
    parameter:draw()
end

function restart()
    love.event.quit('restart')
end

function reload()
    process = {}
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
