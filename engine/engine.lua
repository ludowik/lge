function love.load()
    initMode()
    initTime()
    initParameter()

    reload()
end

function initTime()
    DeltaTime = 0
    ElapsedTime = 0
end

function initMode()
        if getOS() == 'ios' then
        X, Y, W, H = love.window.getSafeArea()
    else
        X, Y, W, H = 10, 20, 800*9/16, 800
        love.window.setMode(2*X+W, 2*Y+H)
    end
end

function initParameter()
    parameter = Parameter()
    parameter:group('menu')
    parameter:action('quit', quit)
    parameter:action('update', function () parameter.scene = UpgradeApp() end)
    parameter:action('reload', reload)
    parameter:action('restart', restart)

    parameter:group('navigate')
    parameter:action('next', function () process:next() end)
    parameter:action('previous', function () process:previous() end)
    parameter:action('random', function () process:random() end)

    parameter:group('info')
    parameter:watch('fps', 'getFPS()')
    parameter:watch('position', 'X..","..Y')
    parameter:watch('size', 'W..","..H')
    parameter:watch('delta time', 'string.format("%.3f", DeltaTime)')
    parameter:watch('elapsed time', 'string.format("%.1f", ElapsedTime)')

    parameter:group('mouse', true)
    parameter:watch('startPosition', 'mouse.startPosition')
    parameter:watch('position', 'mouse.position')
    parameter:watch('previousPosition', 'mouse.previousPosition')
    parameter:watch('move', 'mouse.move')
end

function updateTime(dt)
    DeltaTime = dt
    ElapsedTime = ElapsedTime + dt
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
    updateTime(dt)

    local process = {process:current()}
    for _, sketch in ipairs(process) do
        sketch:updateSketch(dt)
    end
    parameter:update(dt)
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
