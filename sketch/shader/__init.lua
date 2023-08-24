function setup()
    shader = Shader('shader')

    SHAPE_SIZE = 0.5
    parameter:number('SHAPE_SIZE', 'SHAPE_SIZE')

    SMOOTHNESS = 0.5
    parameter:number('SMOOTHNESS', 'SMOOTHNESS')

    parameter:boolean('paused', 'paused', true)

    parameter:integer('depth', 'z', 3)
end

function update(dt)
    shader:update(dt)

    if shader.program then
        if not paused then
            shader.program:send('TIME', ElapsedTime);
        end
        shader.program:send('TIMESCALE', 1.);
        shader.program:send('SHAPE_SIZE', SHAPE_SIZE);
        shader.program:send('SMOOTHNESS', SMOOTHNESS);
        shader.program:send('z', z);
        shader.program:send('CAMERA_POS_WORLD', {0., 2., -5.})
        shader.program:send('MAX_STEPS', 100)
        shader.program:send('MAX_DIST', 100)
        shader.program:send('SURF_DIST', 0.01)
    end
end

function draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setShader(shader.program)

    local mesh = love.graphics.newMesh({
        {0, 0, 0, 0, 1, 1, 1, 1},
        {W, 0, 1, 0, 1, 0, 1, 1},
        {W, H, 1, 1, 1, 1, 0, 1},
        {0, H, 0, 1, 1, 1, 1, 1}
    }, 'fan')

    love.graphics.draw(mesh, 0, 0)

    love.graphics.setShader()

    if shader.errorMsg then
        fontSize(12)
        textColor(colors.gray)
        text(shader.errorMsg, 0, H/2, W)
    end
end
