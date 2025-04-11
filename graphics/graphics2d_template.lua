Graphics2d_template = class()

function Graphics2d_template.setup()
    --push2globals(Graphics2d_template)
end

function Graphics2d_template.background(clr, ...)
    Graphics2d.background(clr, ...)
end

function Graphics2d_template.point(x, y)
    if type(x) == 'table' then x, y = x.x, x.y end
end

function Graphics2d_template.points(...)
end

function Graphics2d_template.line(x1, y1, x2, y2)
    lines{{x1, y1, x2, y2}}
end

local mesh, data, n
function Graphics2d_template.lines(lines)
end

function Graphics2d_template.polyline(vertices)
end

function Graphics2d_template.polygon(vertices)
end

function Graphics2d_template.rect(x, y, w, h, radius, ...)
    stroke(fill())

    Graphics2d_template.line(x, y, x+w, y)
    Graphics2d_template.line(x+w, y, x+w, y+h)
    Graphics2d_template.line(x+w, y+h, x, y+h)
    Graphics2d_template.line(x, y+h, x, y)
end

function Graphics2d_template.circle(x, y, radius)
end

function Graphics2d_template.ellipse(x, y, rx, ry, mode)
end

function Graphics2d_template.arc(x, y, rx, ry, a1, a2)
end

function Graphics2d_template.textSize(str, limit)
    return str:len(), 15
end

function Graphics2d_template.text(str, x, y, limit, align)
    return Graphics2d_template.textSize(str, limit)
end

function Graphics2d_template.spriteSize(image)
    return 100, 100
end

function Graphics2d_template.sprite(image, x, y, w, h, ox, oy, ow, oh)
end
