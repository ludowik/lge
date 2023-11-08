function setup()
    noLoop()
end

function rects()
    local size = 50
    local n = 10

    for j = -n, n do
        for i = (-n - j % 2), (n + j % 2), 2 do
            rect(i * size, j * size, size, size)
        end
    end
end

function draw()
    background(colors.black)

    blendMode(ADD)

    translate(W / 2, H / 2)

    rectMode(CENTER)
    noStroke()

    rotate(ElapsedTime)
    fill(colors.red)
    rects()

    rotate(-ElapsedTime * 4 / 3)
    fill(colors.green)
    rects()

    rotate(ElapsedTime / 2)
    fill(colors.blue)
    rects()
end

function mousepressed()
    loop()
end

function mousereleased()
    noLoop()
end
