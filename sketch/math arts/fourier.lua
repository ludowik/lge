function setup()
    supportedOrientations(LANDSCAPE_ANY)

    angle = 0
    radius = W / 8

    vertices = Array()

    parameter:watch('vertices')
    parameter:integer('series', 1, 3, 1)
    parameter:integer('N', 1, 100, 5)
end

function update(dt)
    angle = angle + dt
    if #vertices > W then
        vertices:pop()
    end
end

function draw()
    background()

    local x = 50 + radius
    local y = H / 2

    local n, len
    for i=0,N do
        if series == 1 then
            n = i * 2 + 1
            len = radius * 4 / (n * PI)
        elseif series == 2 then
            n = (i + 1) * (i%1 == 1 and -1 or 1)
            len = radius * 2 / (n * PI)
        else
            n = i * 2 + 1
            len = radius * 8 * (-1)^((n-1)/2) / (n^2 * PI^2)
        end

        strokeSize(1)
        noFill()
        circle(x, y, len)

        local px = len * cos(n*angle)
        local py = len * sin(n*angle)

        line(x, y, x+px, y+py)
        strokeSize(5)
        point(x+px, y+py)

        x = x + px
        y = y + py
    end

    vertices:insert(1, vec2(x, y))

    strokeSize(1)
    beginShape()
    do
        vertex(x, y)
        vertex(50 + radius*3, y)

        for i=1,#vertices do
            vertex(50 + radius*3 + i, vertices[i].y)
        end
    end
    endShape()
end
