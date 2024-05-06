Graphics = class()

function Graphics.setup()
    push2globals(Graphics)

    font = love.graphics.newFont(25)

    screenRatios = Array{
        ipad = 3/4,
        iphone = 9/19.5,
        iphone_8 = 9/16,
        iphone_4 = 3/4,
    }

    TOP_LEFT = 'top_left'
    BOTTOM_LEFT = 'bottom_left'

    PORTRAIT = 'portrait'
    LANDSCAPE = 'landscape'

    Graphics.initMode()
    Graphics.lights = {
        Light.sun(),
        --Light.ambient(colors.white, 0.8),
    }
end

function Graphics.getSafeArea()
    deviceOrientation = getSetting('deviceOrientation', PORTRAIT)
    deviceScreenRatio = getSetting('deviceScreenRatio', screenRatios.ipad)

    local x, y, w, h
    if getOS() == 'ios' then
        x, y, w, h = love.window.getSafeArea()
    else
        x, y = 5, 50
        local ws, hs = love.window.getDesktopDimensions(1) -- displayindex

        local ratio = deviceScreenRatio
        if deviceOrientation == LANDSCAPE then
            ratio = 1 / ratio
        end

        local p = 0.85
        if floor(hs * p * ratio) <= ws then
            hs = round(hs * p)
            ws = round(hs * ratio)
        else
            ws = round(ws * p)
            hs = round(ws / ratio)
        end

        w = ws - 2*x
        h = hs - 2*y
    end

    -- local margeExtension = 5

    -- x = x + margeExtension
    -- w = w - margeExtension * 2

    return x, y, w, h
end

function Graphics.initMode()
    love.window.setVSync(1)

    local ws, hs, flags = love.window.getMode()

    X, Y, W, H = Graphics.getSafeArea()

    CX = W/2
    CY = H/2
    
    MIN_SIZE = min(W, H)
    MAX_SIZE = max(W, H)

    SIZE = MIN_SIZE
    
    LEFT = X
    TOP = Y

    if getOS() == 'ios' then
        Graphics.setMode(ws, hs, true)
    else
        Graphics.setMode(2*X+W, 2*Y+H, false)
    end

    if getOS() == 'macos' then
        refreshRate = flags.refreshrate * 2
    else
        refreshRate = flags.refreshrate
    end

    devicePixelRatio = love.window.getDPIScale()
end

function Graphics.setMode(w, h, fullscreen)
    local params = {
        msaa = 3,
        fullscreen = fullscreen,
    }

    if love.getVersion() < 12 then
        params.highdpi = true
    end

    local ws, hs, flags = love.window.getMode()
    if not Graphics.initializedScreen or ws ~= w or h ~= h then
        Graphics.initializedScreen = true
        love.window.setMode(w, h, params)
    end
end

function Graphics:rotateScreen()
    initMode()

    local process = processManager:current()
    if not process then return end

    Sketch.fb = nil
    process:setMode(W, H, process.persistence)
    process:resize()

    redraw()
end

function Graphics.noLoop()
    local process = processManager:current()
    if not process then return end

    process.frames = 1
end

function Graphics.loop()
    local process = processManager:current()
    if not process then return end

    process.frames = nil
end

function Graphics.supportedOrientations(orientation)
end
