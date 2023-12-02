function setup()
    parameter:boolean('rotate', 'rotateScene', false)
    parameter:boolean('ccw', true)
    parameter:boolean('cull back', 'cullBack', true)
    parameter:boolean('lequal', true)

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

    love.graphics.setFrontFaceWinding(ccw and 'ccw' or 'cw')
    love.graphics.setMeshCullMode(cullBack and 'back' or 'front')
    love.graphics.setDepthMode(lequal and 'lequal' or 'gequal', true)

    fill(colors.white)

    isometric(3)
    scale(1, -1, 1)

    -- perspective()
    -- camera(vec3(20, 20, -20))

    rotate(angleX, 1, 0, 0)
    rotate(angleY, 0, 1, 0)

    box(0, 0, 0, 50)
end

function mousemoved(mouse)
    angleX = angleX + mouse.deltaPos.y * TAU / (W/2)
    angleY = angleY - mouse.deltaPos.x * TAU / (W/2)
end
