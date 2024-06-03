function setup()
    wn = random(10^5)
    hn = random(10^5)

    update()
    xp, yp = x, y
end

function update()
    x = noise(wn + elapsedTime) * W
    y = noise(hn + elapsedTime) * H

    x = x + noise(wn + elapsedTime*10) * 50
    y = y + noise(hn + elapsedTime*10) * 50

    love.mouse.setPosition(x, y)
end

function draw()
    stroke(Color.hsl(elapsedTime))

    line(xp, yp, x, y)
    xp, yp = x, y
end

