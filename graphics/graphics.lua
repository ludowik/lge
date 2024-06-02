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
        local ws, hs, flags = love.window.getMode()

        x, y, w, h = love.window.getSafeArea()
        
        local r = (w + 2*x) / ws
        w = r * ws - 2*x

        if deviceOrientation == LANDSCAPE then
            x, y = max(x, y), min(x, y)
            w, h = max(w, h), min(w, h)
        else
            x, y = min(x, y), max(x, y)
            w, h = min(w, h), max(w, h)
        end

    else
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

        x, y = 5, 50
        w = ws -- 2*x
        h = hs -- 2*y
    end

    return x, y, w, h
end

function Graphics.initMode()
    love.window.setVSync(1)

    local ws, hs, flags = love.window.getMode()

    LEFT, TOP, W, H = Graphics.getSafeArea()

    CX = W/2
    CY = H/2
    
    MIN_SIZE = min(W, H)
    MAX_SIZE = max(W, H)

    SIZE = MIN_SIZE
    
    Graphics.setMode(W, H, getOS() == 'ios')

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
        -- params.highdpi = true
    end

    local ws, hs, flags = love.window.getMode()
    if not Graphics.initializedScreen or ws ~= w or h ~= h then
        Graphics.initializedScreen = true
        love.window.setMode(w, h, params)
    end
end

function Graphics:rotateScreen()
    initMode()

    local sketch = processManager:current()

    Sketch.fb = nil
    sketch:setMode(W, H, sketch.persistence)
    sketch:resize()

    redraw()
end

function Graphics.noLoop()
    local sketch = processManager:current()
    sketch.loopMode = 'none'
end

function Graphics.loop()
    local sketch = processManager:current()
    sketch.loopMode = 'loop'
end

function Graphics.supportedOrientations(orientation)
end
