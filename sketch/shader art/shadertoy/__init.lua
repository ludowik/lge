function setup()
    setOrigin(BOTTOM_LEFT)

    path = 'sketch/shader art/shadertoy'

    shaders = Array()

    local directoryItems = love.filesystem.getDirectoryItems(path)
    for _,itemName in ipairs(directoryItems) do
        if itemName:contains('pixel') then 
            local name = itemName:gsub('%.pixel.glsl', '')
            shaders:add(Shader(name, path))
        end
    end

    local directoryItems = love.filesystem.getDirectoryItems(path..'/shadertoy')
    for _,itemName in ipairs(directoryItems) do
        local name = itemName:gsub('%.glsl', '')
        shaders:add(ShaderToy(name, path..'/shadertoy'))
    end

    shaderChannel = {
        [0] = Image(path..'/channel/cube00_0.jpg')
    }

    parameter:number('SHAPE_SIZE', 0.1, 2.5, 0.5)
    parameter:number('SMOOTHNESS', 0, 1, 0.5)

    parameter:boolean('paused', false)

    parameter:integer('depth', 'z', 3)
    parameter:integer('shader', 'shaderIndex', 1, #shaders, #shaders)
end

function update(dt)
    local shader = shaders[shaderIndex]
    shader:update(dt)

    if shader.program then
        if not paused then
            shader:sendUniform('iTime', ElapsedTime);
        end
        shader:sendUniform('iChannel0', shaderChannel[0].texture);
        shader:sendUniform('TIMESCALE', 1.);
        shader:sendUniform('SHAPE_SIZE', SHAPE_SIZE);
        shader:sendUniform('SMOOTHNESS', SMOOTHNESS);
        shader:sendUniform('z', z);
        shader:sendUniform('CAMERA_POS_WORLD', {0., 2., -5.})
        shader:sendUniform('MAX_STEPS', 100)
        shader:sendUniform('MAX_DIST', 100)
        shader:sendUniform('SURF_DIST', 0.01)
    end
end

function draw()
    background()
    
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
        text(shader.errorMsg, 0, CY, W)
    end
end
