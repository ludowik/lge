function setup()
    setOrigin(BOTTOM_LEFT)

    path = 'sketch/shader art/shadertoy'

    shaders = Array()

    local directoryItems = love.filesystem.getDirectoryItems(path)
    for _,itemName in ipairs(directoryItems) do
        if itemName:contains('pixel') then 
            local name = itemName:gsub('%.pixel.glsl', '')
            shaders:add(Shader(name, path..'/shaders'))
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

    shaderIndex = getSetting('shaderIndex', 1)

    parameter:integer('shader', 'shaderIndex', 1, #shaders, #shaders, function ()
        setSetting('shaderIndex', shaderIndex)
    end)

    parameter:watch('shader name', 'shaders[shaderIndex].name')
end

function update(dt)
    local shader = shaders[shaderIndex]
    shader:update(dt)

    if shader.program then
        if not paused then
            shader:sendUniform('iTime', elapsedTime);
        end
        shader:sendUniforms{
            iChannel0 = shaderChannel[0].texture,
            iMouse = vec4(mouse.position.x, H-mouse.position.y, mouse.startPosition.x, mouse.startPosition.y),
            TIMESCALE = 1.,
            SHAPE_SIZE = SHAPE_SIZE,
            SMOOTHNESS = SMOOTHNESS,
            z = z;
            CAMERA_POS_WORLD = vec3(0., 2., -5.),
            MAX_STEPS = 100,
            MAX_DIST = 100,
            SURF_DIST = 0.01,
        }
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
