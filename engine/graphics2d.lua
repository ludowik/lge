Graphics2d = class()

function Graphics2d.setup()
    initMode()
    push2globals(Graphics2d)
    font = love.graphics.newFont(25)
end

function initMode()
    if getOS() == 'ios' then
        X, Y, W, H = love.window.getSafeArea()
    else
        X, Y, W, H = 10, 20, 800*9/16, 800
        love.window.setMode(2*X+W, 2*Y+H)
    end
end

function Graphics2d.background(clr, ...)
    clr = Color.fromParam(clr, ...) or colors.black
    love.graphics.setColor(clr.r, clr.g, clr.b, clr.a)
    love.graphics.rectangle('fill', -X, -Y, 2*X+W, 2*Y+H)
end

local styles = {}
function stylesSet(name, value)
    if value then
        styles[name] = value
    end
    return styles[name]
end

function stylesGet(name, value)
    return styles[name]
end

function stylesReset(name)
    styles[name] = nil
end

function Graphics2d.resetStyle()
    stroke(colors.white)
    strokeSize(1)	

    noFill()

    rectMode(CORNER)

    circleMode(CENTER)
    ellipseMode(CENTER)
    
    textMode(CORNER)
    textColor(colors.white)
    fontSize(24)    
end

function Graphics2d.noFill()
    stylesReset('fillColor')
end

function Graphics2d.fill(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('fillColor', clr)
end

function Graphics2d.noStroke()
    stylesReset('strokeColor')
end

function Graphics2d.stroke(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('strokeColor', clr)
end

function Graphics2d.strokeSize(size)
    return stylesSet('strokeSize', size)
end

function Graphics2d.point(x, y)
    if stroke() then
        love.graphics.setColor(stroke():rgba())
    end
    --love.graphics.setPointSize(strokeSize())
    --love.graphics.points(x, y)

    love.graphics.ellipse('fill', x, y, strokeSize()/2, strokeSize()/2)
end

function Graphics2d.points(...)
    if stroke() then
        love.graphics.setColor(stroke():rgba())
    end
    love.graphics.setPointSize(strokeSize())
    love.graphics.points(...)
end

function Graphics2d.line(x1, y1, x2, y2)
    if stroke() then
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.line(x1, y1, x2, y2)
    end
end

function Graphics2d.rectMode(mode)
    return stylesSet('rectMode', mode)
end

function Graphics2d.rect(x, y, w, h, radius)
    local mode = rectMode()
    
    if mode == CENTER then
        x, y = x-w/2, y-h/2
    end

    if fill() then
        love.graphics.setColor(fill():rgba())
        love.graphics.rectangle('fill', x, y, w, h, radius)
    end
    if stroke() then
        local width = strokeSize()
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(width)
        love.graphics.rectangle('line', x+width/2, y+width/2, w-width, h-width, radius)
    end
end

function Graphics2d.circleMode(mode)
    return stylesSet('circleMode', mode)
end

function Graphics2d.circle(x, y, radius)
    Graphics2d.ellipse(x, y, radius, radius, circleMode())
end

function Graphics2d.ellipseMode(mode)
    return stylesSet('ellipseMode', mode)
end

function Graphics2d.ellipse(x, y, rx, ry, mode)
    ry = ry or rx
    mode = mode or ellipseMode()

    if mode == CORNER then
        x, y = x-rx, y-ry
    end

    if fill() then
        love.graphics.setColor(fill():rgba())
        love.graphics.ellipse('fill', x, y, rx, ry)
    end
    if stroke() then
        local size = strokeSize()
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(size)
        love.graphics.ellipse('line', x, y, rx-size/2, ry-size/2)
    end
end

CENTER = 'center'
CORNER = 'corner'

function Graphics2d.textColor(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('textColor', clr)
end

function Graphics2d.textMode(mode)
    return stylesSet('textMode', mode)
end

function Graphics2d.text(str, x, y, limit, align)
    if Graphics2d.textColor() == nil then return end

    str = tostring(str)
    
    x = x or 0
    y = y or 0

    if limit then
        align = align or 'left'
    end
    
    local mode = textMode()
    local ws, hs = textSize(str, limit, align)

    love.graphics.setColor(Graphics2d.textColor():rgba())
    
    if mode == CENTER then
        x, y = x-ws/2, y-hs/2
    end

    if limit then
        love.graphics.printf(str, x, y, limit, align)
    else
        love.graphics.print(str, x, y)
    end
end

function Graphics2d.textSize(str, limit)
    str = tostring(str)

    local font, w, h = love.graphics.getFont()
    if limit then
        local wrappedtext
        w, wrappedtext = font:getWrap(str, limit or W)
        h = font:getHeight() * #wrappedtext
    else
        w = font:getWidth(str)
        h = font:getHeight()
    end
    return w, h
end
