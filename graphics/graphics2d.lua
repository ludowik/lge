Graphics2d = class()

function Graphics2d.setup()
    push2globals(Graphics2d)
end

function Graphics2d.background(clr, ...)
    clr = Color.fromParam(clr, ...) or colors.black
    Graphics.backgroundColor = clr
    love.graphics.setColor(clr.r, clr.g, clr.b, clr.a)
    love.graphics.rectangle('fill', 0, 0, W, H)
end

function Graphics2d.point(x, y)
    if type(x) == 'table' then x, y = x.x, x.y end
    if stroke() then
        love.graphics.setColor(stroke():rgba())
    end

    local r = strokeSize() / 2
    love.graphics.circle('fill', x, y, r)
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

function Graphics2d.lines(lines)
    for _,attr in ipairs(lines) do
        if type(attr[5]) == 'number' then
            stroke(attr[5], attr[6], attr[7], attr[8])
        elseif classnameof(attr[5]) == 'Color' then
            stroke(attr[5])
        end

        Graphics2d.line(attr[1], attr[2], attr[3], attr[4])
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
    if #vertices < 4 then return end
    if stroke() then
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.polygon('line', vertices)
    end
    if fill() then
        love.graphics.setColor(fill():rgba())
        love.graphics.polygon('fill', vertices)
    end
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

function Graphics2d.circle(x, y, radius)
    Graphics2d.ellipse(x, y, radius, radius, circleMode())
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

function Graphics2d.arc(x, y, radius, a1, a2, segments)
    segments = segments or 64

    if fill() then
        love.graphics.setColor(fill():rgba())
        love.graphics.arc('fill', 'pie', x, y, radius, a1, a2, segments)
    else
        local size = strokeSize()
        love.graphics.setColor(stroke():rgba())
        love.graphics.setLineWidth(size)
        love.graphics.arc('line', 'open', x, y, radius, a1, a2, segments)
    end
end

function Graphics2d.textSize(str, limit)
    str = tostring(str)

    local font = FontManager.getFont()
    
    love.graphics.setFont(font)

    local w, h = 0, 0
    if limit then
        local wrappedtext = 0
        w, wrappedtext = font:getWrap(str, limit or W)
        h = font:getHeight() * #wrappedtext
    else
        w = font:getWidth(str)
        h = font:getHeight()
    end
    return w, h
end

function Graphics2d.text(str, x, y, limit, align)
    if Graphics.textColor() == nil then return end

    str = tostring(str)

    x = x or 0
    y = y or 0

    if limit then
        align = align or 'left'
    end

    local ws, hs = textSize(str, limit)

    textPosition(y + hs)
    
    love.graphics.setColor(Graphics.textColor():rgba())

    local mode = textMode()
    if mode == CENTER then
        x, y = x - ws / 2, y - hs / 2
    end

    if not limit and align == 'right' then
        x = x - ws
    end

    local font = FontManager.getFont()

    local newText = love.graphics.newTextBatch or love.graphics.newText
    if not newText then
        love.graphics.text(str, x, y)
        return
    end

    local text = getResource('font', tostring(font)..str, function ()
        local text = newText(font, str)
        return text
    end)

    local sx, sy = 1, Graphics.styles.origin == BOTTOM_LEFT and -1 or 1
    love.graphics.draw(text, x, y, 0, sx, sy)

    return ws, hs
end

function Graphics2d.spriteSize(image)
    return image:getWidth(), image:getHeight()
end

function Graphics2d.sprite(image, x, y, w, h, ox, oy, ow, oh)
    if type(image) == 'string' then
        image = Graphics.image(image)
    end

    x = x or 0
    y = y or 0

    image:update()

    local texture = image:getTexture()
    local mode = spriteMode()

    w = w or image:getWidth()
    h = h or image:getHeight()

    ow = ow or image:getWidth()
    oh = oh or image:getHeight()

    if mode == CENTER then
        x, y = x - w / 2, y - h / 2
    end

    if Graphics.tint() then
        love.graphics.setColor(Graphics.tint():rgba())
    end
    
    love.graphics.draw(texture,
        x, y,
        0,
        w / ow, h / oh,
        ox, oy)
end
