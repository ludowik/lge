Graphics2d = class()

function Graphics2d.setup()
    push2globals(Graphics2d)
end

function Graphics2d.background(clr, ...)
    clr = Color.fromParam(clr, ...) or colors.black
    love.graphics.setColor(clr.r, clr.g, clr.b, clr.a)
    love.graphics.rectangle('fill', 0, 0, W, H)
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

function Graphics2d.resetStyle(origin)
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

    fontName('comic')
    fontSize(22)

    noLight()
    noMaterial()

    styles.origin = origin or TOP_LEFT
end

NORMAL = 'alpha'
ADD = 'add'
SUBTRACT = 'subtract'
MULTIPLY = 'multiply'

function Graphics2d.blendMode(mode)
    if mode == MULTIPLY then
        love.graphics.setBlendMode(MULTIPLY, 'premultiplied')
    else
        love.graphics.setBlendMode(mode)
    end
end

function Graphics2d.fill(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('fillColor', clr)
end

function Graphics2d.noFill()
    stylesReset('fillColor')
end

function Graphics2d.tint(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('tintColor', clr)
end

function Graphics2d.noTint()
    stylesReset('tintColor')
end

function Graphics2d.stroke(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('strokeColor', clr)
end

function Graphics2d.noStroke()
    stylesReset('strokeColor')
end

function Graphics2d.strokeSize(size)
    return stylesSet('strokeSize', size)
end

function Graphics2d.light(lights)
    if type(lights) == 'table' then
        stylesSet('lights', lights)
    elseif type(lights) == 'boolean' then
        stylesSet('lights', Graphics2d.lights)
    end
    return stylesGet('lights')
end

function Graphics2d.noLight()
    stylesReset('light')
end

function Graphics2d.noMaterial()
    stylesReset('material')
end

function Graphics2d.zLevel()
end

function Graphics2d.axes2d()
    pushMatrix()
    resetMatrix()

    stroke(colors.gray)
    strokeSize(0.5)

    translate(CX, CY)

    local len = max(W, H)

    line(-len, 0, len, 0)
    line(0, -len, 0, len)

    popMatrix()
end

function Graphics2d.grid2d(size)
    size = size or 32

    pushMatrix()
    resetMatrix()

    stroke(colors.gray)
    strokeSize(0.5)

    translate(CX, CY)

    local len = max(W, H)

    local m = ceil(W / size / 2) - 1
    local n = ceil(H / size / 2)

    line(-len, 0, len, 0)
    line(0, -len, 0, len)

    stroke(colors.gray:alpha(0.25))

    for x=-m,m do
        line(x*size, -len, x*size, len)
    end

    for y=-n,n do
        line(-len, y*size, len, y*size)
    end

    fontSize(10)
    textMode(CENTER)

    local index = -n*10
    for y=-n,n,0.1 do
        if index%10 == 0 then
            len = 15
            text(-index/10, -m*size+15, y*size-2)
        elseif index%5 == 0 then
            len = 10
        else
            len = 5
        end
        line(-m*size, y*size, -m*size+len, y*size)
        
        index = index + 1        
    end

    index = -m*10
    for x=-m,m,0.1 do
        if index%10 == 0 then
            len = 15
            text(index/10, x*size, n*size-15)
        elseif index%5 == 0 then
            len = 10
        else
            len = 5
        end
        line(x*size, n*size, x*size, n*size-len)
        
        index = index + 1        
    end

    popMatrix()
end

function Graphics2d.point(x, y)
    if type(x) == 'table' then x, y = x.x, x.y end
    if stroke() then
        love.graphics.setColor(stroke():rgba())
    end

    local r = strokeSize() / 2
    love.graphics.circle('fill', x+r, y+r, r)
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

function Graphics2d.polyline(vertices)
    if stroke() and #vertices >= 4 then
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.line(vertices)
    end
end

function Graphics2d.polygon(vertices)
    if stroke() and #vertices >= 4 then
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.polygon('line', vertices)
    end
end

function Graphics2d.rectMode(mode)
    return stylesSet('rectMode', mode)
end

function Graphics2d.rect(x, y, w, h, radius, ...)
    local mode = rectMode()

    if mode == CENTER then
        x, y = x - w / 2, y - h / 2
    end

    if fill() then
        love.graphics.setColor(fill():rgba())
        love.graphics.rectangle('fill', x, y, w, h, radius, ...)
    end
    if stroke() then
        local width = strokeSize()
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(width)
        love.graphics.rectangle('line', x + width / 2, y + width / 2, w - width, h - width, radius, ...)
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
        x, y = x - rx, y - ry
    end

    local segments = 64

    if fill() then
        love.graphics.setColor(fill():rgba())
        love.graphics.ellipse('fill', x, y, rx, ry, segments)
    end
    if stroke() then
        local size = strokeSize()
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(size)
        love.graphics.ellipse('line', x, y, rx - size / 2, ry - size / 2, segments)
    end
end

function Graphics2d.arc(x, y, rx, ry, a1, a2)
    local segments = 64

    if fill() then
        love.graphics.setColor(fill():rgba())
        love.graphics.arc('fill', x, y, rx, a1, a2, segments)
    else
        local size = strokeSize()
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(size)
        love.graphics.arc('line', x, y, rx, a1, a2, segments)
    end
end

CENTER = 'center'
CORNER = 'corner'
RIGHT_CORNER = 'righ_corner'

function Graphics2d.textColor(clr, ...)
    clr = Color.fromParam(clr, ...)
    return stylesSet('textColor', clr)
end

function Graphics2d.textMode(mode)
    return stylesSet('textMode', mode)
end

function Graphics2d.textPosition(y)
    return stylesSet('textPosition', y)
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
    local ws, hs = textSize(str, limit)

    textPosition(y + hs)
    
    love.graphics.setColor(Graphics2d.textColor():rgba())

    if mode == CENTER then
        x, y = x - ws / 2, y - hs / 2
    end

    if not limit and align == 'right' then
        x = x - ws
    end

    local font = FontManager.getFont()

    local newText = love.graphics.newTextBatch or love.graphics.newText

    local text = getResource(tostring(font)..str, function ()
        local text = newText(font, str)
        return text
    end)

    local sx, sy = 1, styles.origin == BOTTOM_LEFT and -1 or 1
    love.graphics.draw(text, x, y, 0, sx, sy)

    -- if limit then
    --     love.graphics.printf(str, x, y, limit, align, 0, sx, sy)
    -- else
    --     love.graphics.print(str, x, y, 0, sx, sy)
    -- end

    return ws, hs
end

function Graphics2d.textSize(str, limit)
    str = tostring(str)

    local font = FontManager.getFont()
    
    love.graphics.setFont(font)

    local w, h
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

function Graphics2d.spriteMode(mode)
    return stylesSet('spriteMode', mode)
end

function Graphics2d.spriteSize(image)
    local texture = image.texture or image.canvas
    return texture:getWidth(), texture:getHeight()
end

function Graphics2d.sprite(image, x, y, w, h, ox, oy, ow, oh)
    x = x or 0
    y = y or 0

    image:update()

    local texture = image.texture or image.canvas

    local mode = spriteMode()
    w = w or texture:getWidth()
    h = h or texture:getHeight()

    ow = ow or texture:getWidth()
    oh = oh or texture:getHeight()

    if mode == CENTER then
        x, y = x - w / 2, y - h / 2
    end

    if Graphics2d.tint() then
        love.graphics.setColor(Graphics2d.tint():rgba())
    end
    
    love.graphics.draw(texture,
        x, y,
        0,
        w / ow, h / oh,
        ox, oy)
end
