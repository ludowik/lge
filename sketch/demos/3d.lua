
function draw()
    background()

    love.graphics.setDepthMode('gequal', true)

    translate(W/2, H/2)

    rotate(ElapsedTime, 0, 1)

    rectMode(CENTER)
    rect(0, 0, 200, 200)
end
