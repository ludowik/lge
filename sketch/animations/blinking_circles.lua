function setup()
    randoms = {}
    zoom = 1

    parameter:integer('c1', 1, 100, 1)
    parameter:integer('c2', 1, 100, 2)
    parameter:integer('c3', 1, 100, 12)
    parameter:number('alpha', 0, 1, 0.75)

    background(colors.white)
end

function draw()
    screenBlur(alpha, alpha, alpha, alpha)

    noStroke()
    circleMode(CENTER)

    scale(zoom)

    drawCircles(c1, 0.15)
    drawCircles(c2, 0.2)
    drawCircles(c3)
end

function drawCircles(n, a)
    local anchor = Anchor(n)

    local w = anchor:size().x
    local m = anchor.nj

    randoms[n] = randoms[n] or {}

    local index = 0
    for x = 1, n do
        for y = -1, m+2 do
            index = index + 1
            randoms[n][index] = randoms[n][index] or (random() * 6)

            local noiseValue = randoms[n][index] + ElapsedTime * noise(index, randoms[n][index])

            local value =      (cos(noiseValue) + 1) / 2            
            local radius = w * (sin(noiseValue) + 1) / 4

            fill(value, 0.5, 0.5, a)
            
            circle(-w/2+x*w, -w/2+y*w, radius)
        end
    end
end
