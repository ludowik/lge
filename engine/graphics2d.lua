Graphics2d = class()

local __paramColor = Color()
function paramColor(clr, ...)
    if clr == nil then return end
    if type(clr) == 'table' then return clr end
    return __paramColor:setComponents(clr, ...)
end

function Graphics2d.background(clr, ...)
    clr = paramColor(clr, ...) or colors.black    
    love.graphics.clear(clr.r, clr.g, clr.b, clr.a)
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
    textMode(CORNER)
    textColor(colors.white)

    noStroke()
    strokeWidth(5)

    fill(colors.gray)
end

function Graphics2d.noFill()
    stylesReset('fillColor')
end

function Graphics2d.fill(clr, ...)
    clr = paramColor(clr, ...)
    return stylesSet('fillColor', clr)
end

function Graphics2d.noStroke()
    stylesReset('strokeColor')
end

function Graphics2d.stroke(clr, ...)
    clr = paramColor(clr, ...)
    return stylesSet('strokeColor', clr)
end

function Graphics2d.strokeWidth(width)
    return stylesSet('strokeWidth', width)
end

function Graphics2d.line(x1, y1, x2, y2)
    if stroke() then
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(strokeWidth())
        love.graphics.line(x1, y1, x2, y2)
    end
end

function Graphics2d.rect(x, y, w, h)
    if fill() then
        love.graphics.setColor(fill():rgba())
        love.graphics.rectangle('fill', x, y, w, h)
    end
    if stroke() then
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(strokeWidth())
        love.graphics.rectangle('line', x, y, w, h)
    end
end

CENTER = 'center'
CORNER = 'corner'

function Graphics2d.textColor(mode)
    return stylesSet('textColor', mode)
end

function Graphics2d.textMode(mode)
    return stylesSet('textMode', mode)
end

function Graphics2d.text(str, x, y, w)
    if Graphics2d.textColor() == nil then return end

    x = x or 0
    y = y or 0

    w = w or W

    local mode = textMode()
    local ws, hs = textSize(str)

    love.graphics.setColor(Graphics2d.textColor():rgba())
    
    if mode == CENTER then
        love.graphics.printf(str, x-ws/2, y-hs/2, w, 'left')
    else
        love.graphics.printf(str, x, y, w, 'left')
    end
end

function Graphics2d.textSize(str)
    local font = love.graphics.getFont()
    local w = font:getWidth(str)
    local h = font:getHeight()
    return w, h
end
