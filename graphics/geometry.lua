class 'Geometry' 

function Geometry.line(points, x1, y1, x2, y2)
    table.insert(points, vec2(x1, y1))
    table.insert(points, vec2(x2, y2))
end

function Geometry.bresenhamLine(x1, y1, x2, y2, ...)
    local dx = math.abs(x2 - x1)
    local dy = math.abs(y2 - y1)

    local sx = (x1 < x2) and 1 or -1
    local sy = (y1 < y2) and 1 or -1

    local err = dx - dy

    while (true) do
        point(x1, y1, ...)

        if (math.abs(x2 - x1) < 1 and math.abs(y2 - y1) < 1) then break end

        local e2 = 2 * err

        if (e2 > -dy) then
            err = err - dy
            x1 = x1 + sx
        end

        if (e2 < dx) then
            err = err + dx
            y1 = y1 + sy
        end
    end
end

function Geometry.arc(points, x, y, r, a1, a2, n)
    x = x + r
    y = y + r

    a1 = a1 or 0
    a2 = a2 or PI2

    n = n or PI2*.05

    points:insert(vec3(x + r * cos(a1), y + r * sin(a1), 0))
    for a = a1+n, a2, n do
        points:insert(vec3(x + r * cos(a), y + r * sin(a), 0))
    end
    points:insert(vec3(x + r * cos(a2), y + r * sin(a2), 0))
end

function Geometry.draw(points, size, strokeColor)
    style(size, strokeColor)

    local p1 = points[1]

    if #points == 1 then
        circle(p1.x, p1.y, size, size, strokeColor, strokeColor, CENTER)
    else
        for i = 2, #points do
            local p2 = points[i]
            line(p1.x, p1.y, p2.x, p2.y)
            p1 = p2
        end
    end
end
