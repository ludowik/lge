function setup()
    parameter:action('reset', reset)    
    parameter:integer('branches', 2, 6, 2, reset)
end

function reset()
    shape = nil
end

function drawbranches(ax, ay, aa, x, y, a, l, level)
    if level == 0 then
        return
    end

    pushMatrix()

    translate(x, y)
    rotate(a)

    strokeSize(level)
    if l > 10 then
        stroke(155 / 255, 103 / 255, 60 / 255, level / 10)
    else
        stroke(0, 1, 0, level / 10)
    end

    --vertex(ax, ay)
    aa = aa + a
    ax = ax + sin(-aa) * l
    ay = ay + cos(-aa) * l
    --vertex(ax, ay)

    line(0, 0, 0, l)

    level = level - 1

    drawbranches(ax, ay, aa, 0, l, -PI / random(4, 8), l * random(0.3, 0.8), level)
    drawbranches(ax, ay, aa, 0, l,  PI / random(4, 8), l * random(0.3, 0.8), level)

    for i in range(branches) do
        drawbranches(ax, ay, aa, 0, l, random(-PI / 4, PI / 4), l * random(0.5, 0.8), level)
    end

    popMatrix()

    count = count + 1
end

function draw()
    seed(984564)

    background(colors.black)
    scale(1, -1)
    translate(0, -H * 0.95)

    if true or not shape then
        beginShape(LINES)

        local l = random(4, 8)

        count = 0
        drawbranches(CX, 0, 0, CX, 0, 0, H/l, 8)

        stroke(colors.blue)

        shape = endShape()
    end

    shape:draw()
end
