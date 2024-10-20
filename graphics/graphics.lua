Graphics = class()

function Graphics.setup()
    push2globals(Graphics)

    font = FontManager.getFont()

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
        Light.ambient(colors.white, 0.8),
    }
end

function Graphics.initMode()
    love.window.setVSync(1)

    deviceOrientation = getSetting('deviceOrientation', PORTRAIT)

    _, _, WS, HS = Graphics.getPhysicalArea()
    Graphics.setMode(WS, HS)

    LEFT, TOP, W, H = getVirtualArea()

    CX = W/2
    CY = H/2
    
    MIN_SIZE = min(W, H)
    MAX_SIZE = max(W, H)

    SIZE = MIN_SIZE

    SCALE = min(WS/W, HS/H)
    
    refreshRate = 60
end

function Graphics.getPhysicalArea()
    local x, y, w, h
    if getOS() == 'ios' then
        x, y = love.window.getSafeArea()
        w, h = love.window.getDesktopDimensions(1)
        
    elseif getOS() == 'osx' then
        x, y, w, h = 0, 0, 0, 1024
        w = even(h*screenRatios.iphone)
    
    else
        x, y, w, h = 0, 0, 375, 812
    end

    dpiscale = 1
    deviceScreenRatio = min(w/h, h/w)
    
    if deviceOrientation == PORTRAIT then
        return min(x, y), max(x, y), min(w, h), max(w, h)
    end

    return max(x, y), min(x, y), max(w, h), min(w, h)
end

function getVirtualArea()
    local x, y, w, h = 5, 50, 512
    h = even(w / deviceScreenRatio)

    if deviceOrientation == PORTRAIT then
        return x, y, w, h
    end

    return y, x, h, w
end

function Graphics.setMode(w, h)
    local ws, hs, flags = love.window.getMode()
    
    if not Graphics.initializedScreen or ws ~= w or h ~= h then
        Graphics.initializedScreen = true

        local params = {
            msaa = 5,
            fullscreen = getOS() == 'ios',
        }

        love.window.setMode(
            w,
            h,
            params)
    end
end

function Graphics.toggleFullScreen()
    local ws, hs, flags = love.window.getMode()
    if not flags.fullscreen then
        flags.fullscreen = true
        Graphics.flags = {
            x = flags.x,
            y = flags.y,
            ws = ws,
            hs = hs,
        }
    else
        flags.fullscreen = false
        flags.x = Graphics.flags.x
        flags.y = Graphics.flags.y
        ws = Graphics.flags.ws
        hs = Graphics.flags.hs
    end
    love.window.setMode(
        ws,
        hs,
        flags)
end

function Graphics:rotateScreen()
    Graphics.initMode()

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
