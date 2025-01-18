Graphics = class()

function Graphics.setup()
    push2globals(Graphics)

    Graphics.styles = {}

    font = FontManager.getFont()

    screenRatios = Array{
        ipad = 3/4,
        iphone = 9/19.5,
        iphone_8 = 9/16,
        iphone_4 = 3/4,
    }

    screenRatio = getSetting('screenRatio', screenRatios.ipad)

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

function Graphics.setDeviceOrientation(orientation)
    deviceOrientation = orientation
    setSetting('deviceOrientation', deviceOrientation)
    Graphics.updateScreen()
end

function Graphics.toggleDeviceOrientation()
    Graphics.setDeviceOrientation(deviceOrientation == PORTRAIT and LANDSCAPE or PORTRAIT)
end

function Graphics.setVSync(v)
    love.window.setVSync(v)
end

function Graphics.initMode()
    deviceOrientation = getSetting('deviceOrientation', PORTRAIT)

    LEFT, TOP, WS, HS = Graphics.getPhysicalArea()
    
    Graphics.setMode(WS, HS)
    Graphics.setVSync(1)

    _, _, W, H = Graphics.getVirtualArea()

    CX = W/2
    CY = H/2
    
    MIN_SIZE = min(W, H)
    MAX_SIZE = max(W, H)

    SIZE = MIN_SIZE

    SCALE = min(WS/W, HS/H)
    
    refreshRate = 60
end

function Graphics.scaleMouseProperties(x, y)
    return x/SCALE, y/SCALE
end

function Graphics.getPhysicalArea()
    local x, y, w, h

    if getOS() == 'ios' then
        x, y = love.window.getSafeArea()
        w, h = love.window.getDesktopDimensions(love.window.getDisplayCount())
            
    elseif getOS():inList{'osx', 'windows'} then
        local ws, hs, flags = love.window.getMode()
        if flags.fullscreen then
            x, y, w, h = 0, 0, ws, hs
            deviceOrientation = w < h and PORTRAIT or LANDSCAPE
        else
            _, h = love.window.getDesktopDimensions(love.window.getDisplayCount())
            x, y, w, h = 0, 0, 0, h * 0.9
            w = even(h*screenRatio)
        end

    else
        x, y, w, h = 0, 0, 375, 812
    end

    dpiscale = 1
    deviceScreenRatio = min(w/h, h/w)

    x = x + UI.outerMarge
    y = y + UI.outerMarge
    
    if deviceOrientation == PORTRAIT then
        return min(x, y), max(x, y), min(w, h), max(w, h)
    else
        return max(x, y), min(x, y), max(w, h), min(w, h)
    end
end

function Graphics.flush()
    love.graphics.present()
end

function Graphics.getVirtualArea()
    local ws, hs = 0, 0
    if getOS() == 'ios' then
        ws, hs = love.window.getDesktopDimensions()
    elseif getOS():inList{'osx', 'windows'} then
    else
    end

    local x, y, w, h = 5, 50, max(640, min(ws, hs))
    h = even(w / deviceScreenRatio)

    if deviceOrientation == PORTRAIT then
        return x, y, w, h
    else
        return y, x, h, w
    end
end

function Graphics.setMode(w, h)
    local ws, hs, flags = love.window.getMode()
    
    if not Graphics.initializedScreen or ws ~= w or hs ~= h then
        Graphics.initializedScreen = true

        local params = {
            msaa = 3,
            fullscreen = getOS() == 'ios' or flags.fullscreen,
        }

        if love.getVersion() > 11 then
            params.displayindex = love.window.getDisplayCount()
        else
            params.display = love.window.getDisplayCount()
        end

        love.window.setMode(
            w,
            h,
            params)
        love.mouse.setPosition(w/2, h/2)
    end
end

function Graphics.isFullScreen()
    local _, _, flags = love.window.getMode()
    return flags.fullscreen
end

function Graphics.toggleFullScreen()
    Graphics.initializedScreen = false

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

    Graphics.updateScreen()
end

function Graphics.updateScreen()
    Graphics.initMode()

    local sketch = processManager:current()

    Sketch.fb = nil
    sketch:setMode(W, H, sketch.persistence)
    sketch:resize()

    Engine.initParameter()

    redraw()
end

function Graphics.loop()
    local sketch = processManager:current()
    sketch.loopMode = 'loop'
end

function Graphics.noLoop()
    local sketch = processManager:current()
    sketch.loopMode = 'none'
end

function Graphics.redraw()
    local sketch = processManager:current()
    if sketch.loopMode == 'none' then
        sketch.loopMode = 'redraw'
    end
end

function Graphics.toggleLoop()
    local sketch = processManager:current()
    sketch.loopMode = sketch.loopMode == 'loop' and 'none' or 'loop'
end

function Graphics.supportedOrientations(orientation)
end

function Graphics.getBackgroundColor()
    return Graphics.backgroundColor or colors.black
end

local function stylesSet(name, value)
    if value then
        Graphics.styles[name] = value
    end
    return Graphics.styles[name]
end

local function stylesGet(name, value)
    return Graphics.styles[name]
end

local function stylesReset(name)
    Graphics.styles[name] = nil
end

function Graphics.resetStyle(origin)
    blendMode(NORMAL)

    stroke(colors.white)
    strokeSize(1)

    noFill()

    tint(colors.white)

    rectMode(CORNER)

    circleMode(CENTER)
    ellipseMode(CENTER)

    textMode(CORNER)
    textColor(colors.white)
    textPosition(0)

    fontName(DEFAULT_FONT_NAME)
    fontSize(DEFAULT_FONT_SIZE)

    noLight()
    noMaterial()

    Graphics.styles.origin = origin or TOP_LEFT
end

NORMAL = 'alpha'
ADD = 'add'
SUBTRACT = 'subtract'
MULTIPLY = 'multiply'

function Graphics.blendMode(mode)
    mode = stylesSet('blendMode', mode)
    if mode == MULTIPLY then
        love.graphics.setBlendMode(MULTIPLY, 'premultiplied')
    else
        love.graphics.setBlendMode(mode)
    end
    return mode
end

function Graphics.fill(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('fillColor', clr)
end

function Graphics.noFill()
    stylesReset('fillColor')
end

function Graphics.tint(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('tintColor', clr)
end

function Graphics.noTint()
    stylesReset('tintColor')
end

function Graphics.stroke(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('strokeColor', clr)
end

function Graphics.noStroke()
    stylesReset('strokeColor')
end

function Graphics.strokeSize(size)
    return stylesSet('strokeSize', size)
end

function Graphics.light(lights)
    if type(lights) == 'table' then
        stylesSet('lights', lights)
    elseif type(lights) == 'boolean' then
        stylesSet('lights', Graphics.lights)
    end
    return stylesGet('lights')
end

function Graphics.noLight()
    stylesReset('light')
end

function Graphics.noMaterial()
    stylesReset('material')
end

function Graphics.getShader()
    return love.graphics.getShader()
end

function Graphics.setShader(program)
    love.graphics.setShader(program)
end

function Graphics.zLevel()
end

function Graphics.rectMode(mode)
    return stylesSet('rectMode', mode)
end

function Graphics.circleMode(mode)
    return stylesSet('circleMode', mode)
end

function Graphics.ellipseMode(mode)
    return stylesSet('ellipseMode', mode)
end

CENTER = 'center'
CORNER = 'corner'
RIGHT_CORNER = 'righ_corner'

function Graphics.textColor(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('textColor', clr)
end

function Graphics.textMode(mode)
    return stylesSet('textMode', mode)
end

function Graphics.textPosition(y)
    return stylesSet('textPosition', y)
end

Graphics.__imageCache = {}
function Graphics.image(filePath)
    local cache = Graphics.__imageCache
    if not cache[filePath] then
        cache[filePath] = Image(filePath)
    end
    return cache[filePath]
end

function Graphics.spriteMode(mode)
    return stylesSet('spriteMode', mode)
end
