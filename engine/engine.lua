function love.load()
    if getOS() == 'ios' then
        X, Y, W, H = love.window.getSafeArea()
    else
        X, Y, W, H = 10, 20, 408, 640
        love.window.setMode(2*X+W, 2*Y+H)
    end
    
    push2globals(Graphics2d)

    font = love.graphics.newFont(25)

    load()
    
    parameter = Parameter()
    parameter:group('menu', true)
    parameter:action('quit', quit)
    parameter:action('update from git', function () updateScripts(true) end)
    parameter:action('update from local', function () updateScripts(false) end)
    parameter:action('reload', reload)

    parameter:group('info', false)
    parameter:watch('fps', 'getFPS()')
    parameter:watch('position', 'X..","..Y')
    parameter:watch('size', 'W..","..H')
end

function love.update(dt)
    for _, sketch in ipairs(process) do
        sketch:updateSketch(dt)
    end
    parameter:update(dt)
end

function love.draw()
    love.graphics.reset()

    background(Color(251))    
    for _, sketch in ipairs(process) do
        sketch:drawSketch()
    end
    parameter:draw()

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', X, Y, W, H)    
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
