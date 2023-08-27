function setup()
    shaders = {
        Shader('shader'),
        ShaderToy('intro'),
        ShaderToy('twisted_columns'),
        Shader('chladni_plates'),
    }

    parameter:number('SHAPE_SIZE', 'SHAPE_SIZE', 0.1, 2.5, 0.5)
    parameter:number('SMOOTHNESS', 'SMOOTHNESS', 0, 1, 0.5)

    parameter:boolean('paused', 'paused', false)

    parameter:integer('depth', 'z', 3)
    parameter:integer('shader', 'shaderIndex', 1, #shaders, #shaders)

    image = Image('rusty_metal.jpg')
end

function update(dt)
    local shader = shaders[shaderIndex]
    shader:update(dt)

    if shader.program then
        if not paused then
            shader:send('iTime', ElapsedTime);
        end
        shader:send('iChannel0', image.texture);
        shader:send('TIMESCALE', 1.);
        shader:send('SHAPE_SIZE', SHAPE_SIZE);
        shader:send('SMOOTHNESS', SMOOTHNESS);
        shader:send('z', z);
        shader:send('CAMERA_POS_WORLD', {0., 2., -5.})
        shader:send('MAX_STEPS', 100)
        shader:send('MAX_DIST', 100)
        shader:send('SURF_DIST', 0.01)
    end
end

function draw()
    local shader = shaders[shaderIndex]
    
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
