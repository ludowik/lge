function setup()
    parameter:boolean('rotate', 'rotateScene', false)
    parameter:boolean('isometric/perspective', 'isometricMode', true)

    angleX = 0
    angleY = 0
end

function update(dt)
    if rotateScene then
        angleX = angleX + dt
        angleY = angleY + dt
    end
end

function draw()
    background(51)

    if isometricMode then
        isometric(50)
    else
        perspective()
        lookat(vec3(5, 5, 5))
    end

    fill(colors.white)

    rotate(angleX, 1, 0, 0)
    rotate(angleY, 0, 1, 0)

    box()
end

function mousemoved(mouse)
    angleX = angleX + mouse.deltaPos.y * TAU / (W/2)
    angleY = angleY + mouse.deltaPos.x * TAU / (W/2)
end
