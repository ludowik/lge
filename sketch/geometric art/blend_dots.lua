function setup()
    setOrigin(BOTTOM_LEFT)
    
    xx = 0
    yy = 0

    t = 0

    angle = 0
end

function draw()
    background(51)

    blendMode(ADD)

    noStroke()

    local radius = 14
    local dx = 0

    local dt = DeltaTime * 50

    t = t + dt

    if t > 0 then
        xx = xx + dt
        yy = yy + dt
    end

    if xx >= radius*4 then
        t = -10
        xx = 0
    end

    if yy >= radius*4 then
        t = -10
        yy = 0
    end

    for y=-radius*4,H+radius*4,radius*4 do
        if dx == 0 then
            dx = radius*2
        else
            dx = 0
        end

        for x=-radius*4+dx,W+radius*4,radius*4 do
            fill(colors.red)
            circle(x+xx, y, radius)

            fill(colors.green)
            circle(x+yy/2, y+yy, radius)

            fill(colors.blue)
            circle(x, y, radius)
        end
    end
end
