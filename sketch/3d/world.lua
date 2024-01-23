function setup()
    env.sketch:setMode(800, 800, true)

    m = Mesh()

    size = 0.5

    len = 64
    for x=0,len-1 do
        for y=0,len-1 do
            m:addPlane(x*size, y*size, size, size)
        end
    end

    m:computeNormals()

    img = FrameBuffer(len, len, 'r16f')
    for x=0,img.width*devicePixelRatio-1 do
        for z=0,img.height*devicePixelRatio-1 do
            local y = simplexNoise(x*size/10, z*size/10) * 5
            img:set(x, z, y, 0, 0)
        end
    end
    img:update()

    m.image = Image('resources/images/grass.jpeg')
    
    m.uniforms.useHeightMap = true
    m.uniforms.tex = img.texture
    m.uniforms.texWidth = img.width * devicePixelRatio
    m.uniforms.texHeight = img.height * devicePixelRatio

    m.uniforms.useLight = true
    m.uniforms.useLightAmbient = true
    m.uniforms.useLightDiffuse = true
    m.uniforms.useLightSpecular = true
    m.uniforms.lights = {
        Light.ambient(colors.yellow, 0.5),
        Light.directionnal(colors.yellow, vec3(0, 100, 0), 0., 1, 0.15)
    }

    skybox = Mesh(Model.skybox())
    skybox.image = Image('resources/images/skybox2.png')

    local eye = vec3(0, 20, 0)
    camera(eye, eye + vec3(len, -1, len))

    parameter:watch('env.sketch.cam.eye')
    parameter:watch('env.sketch.cam.target')
end

function draw()
    background()
    perspective()
    
    local count = 10

    local instances = Array()
    for x=-count,count-1 do
        for z=-count,count-1 do
            instances:add{x*len*size, 0, z*len*size, 1, 1, 1, 1, 1, 1, 1}
        end
    end

    m:drawInstanced(instances)
    skybox:draw()
end
