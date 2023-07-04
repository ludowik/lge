function love.load()
    if getOS() == 'ios' then
        X, Y, W, H = love.window.getSafeArea()
    else
        X, Y, W, H = 10, 20, 800*9/16, 800
        love.window.setMode(2*X+W, 2*Y+H)
    end
    
    push2globals(Graphics2d)

    font = love.graphics.newFont(25)

    reload()

    DeltaTime = 0
    ElaspedTime = 0
    
    parameter = Parameter()
    parameter:group('menu', true)
    parameter:action('quit', quit)
    parameter:action('update', function () parameter.scene = UpgradeApp() end)
    parameter:action('reload', reload)
    parameter:action('restart', restart)

    parameter:group('navigate', false)
    parameter:action('next', function () process:next() end)
    parameter:action('previous', function () process:previous() end)
    parameter:action('random', function () process:random() end)

    parameter:group('info', false)
    parameter:watch('fps', 'getFPS()')
    parameter:watch('position', 'X..","..Y')
    parameter:watch('size', 'W..","..H')
end

function love.update(dt)
    DeltaTime = dt
    ElaspedTime = ElaspedTime + dt

    local process = {process:current()}
    for _, sketch in ipairs(process) do
        sketch:updateSketch(dt)
    end
    parameter:update(dt)
end

function love.draw()
    love.graphics.reset()

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
    process = Process()
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
