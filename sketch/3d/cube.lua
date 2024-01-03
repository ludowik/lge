function setup()
    parameter:boolean('rotate', 'rotateScene', false)
    parameter:boolean('isometric/perspective', 'isometricMode', false)
    parameter:boolean('border', 'border', true)

    camera(vec3(5, 5, 5))
end

function update(dt)
    if rotateScene then
        sketch.cam.angleX = sketch.cam.angleX + dt
        sketch.cam.angleY = sketch.cam.angleY + dt
    end
end

function draw()
    background(51)

    if isometricMode then
        isometric(50)
    else
        perspective()
    end

    fill(colors.white)

    box()

    if border then
        stroke(colors.red)
        boxBorder()
    end
end
