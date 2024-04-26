function setup()
    wn = random(10^5)
    hn = random(10^5)

    update()
    xp, yp = x, y
end

function update()
    x = noise(wn + ElapsedTime) * W
    y = noise(hn + ElapsedTime) * H

    x = x + noise(wn + ElapsedTime*10) * 50
    y = y + noise(hn + ElapsedTime*10) * 50

    love.mouse.setPosition(X+x, Y+y)
end

function draw()
    stroke(Color.hsl(ElapsedTime))

    line(xp, yp, x, y)
    xp, yp = x, y
end

