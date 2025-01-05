Graphics2d_bis = class()

function Graphics2d_bis.setup()
    --push2globals(Graphics2d_bis)
end

function Graphics2d_bis.background(clr, ...)
    Graphics2d.background(clr, ...)
end

function Graphics2d_bis.point(x, y)
    if type(x) == 'table' then x, y = x.x, x.y end
end

function Graphics2d_bis.points(...)
end

function Graphics2d_bis.line(x1, y1, x2, y2)
    lines{{x1, y1, x2, y2}}
end

local mesh, data, n
function Graphics2d_bis.lines(lines)
    mesh = mesh or Mesh(Model.line(0, 0, 1, 1))
    mesh.shader = Graphics3d.shaders.line

    data = data or Array()
    data:reset()

    for _,attr in ipairs(lines) do
        if type(attr[5]) == 'number' then
            data:add{attr[1], attr[2], 0, attr[3]-attr[1], attr[4]-attr[2], 0, attr[5], attr[6], attr[7], attr[8]}

        elseif classnameof(attr[5]) == 'Color' then
            data:add{attr[1], attr[2], 0, attr[3]-attr[1], attr[4]-attr[2], 0, attr[5]:rgba()}

        else
            data:add{attr[1], attr[2], 0, attr[3]-attr[1], attr[4]-attr[2], 0, (stroke() or colors.white):rgba()}
        end
    end

    mesh:drawInstanced(data, true)
end

function Graphics2d_bis.polyline(vertices)
end

function Graphics2d_bis.polygon(vertices)
end

function Graphics2d_bis.rect(x, y, w, h, radius, ...)
    stroke(fill())

    Graphics2d_bis.line(x, y, x+w, y)
    Graphics2d_bis.line(x+w, y, x+w, y+h)
    Graphics2d_bis.line(x+w, y+h, x, y+h)
    Graphics2d_bis.line(x, y+h, x, y)
end

function Graphics2d_bis.circle(x, y, radius)
end

function Graphics2d_bis.ellipse(x, y, rx, ry, mode)
end

function Graphics2d_bis.arc(x, y, rx, ry, a1, a2)
end

function Graphics2d_bis.textSize(str, limit)
    return 30, 15
end

function Graphics2d_bis.text(str, x, y, limit, align)
end

function Graphics2d_bis.spriteSize(image)
    return 100, 100
end

function Graphics2d_bis.sprite(image, x, y, w, h, ox, oy, ow, oh)
end
