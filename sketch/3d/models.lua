function setup()
    models = Array()

    local directoryItems = love.filesystem.getDirectoryItems('resources/models')
    for _,modelName in ipairs(directoryItems) do
        local model = Model.load(modelName)
        model.vertices = Model.centerVertices(model.vertices)
        models:add(model)
    end

    lights = {
        Light.ambient(colors.yellow, 0.25),
        Light.random()
    }

    materials = {
        Material()
    }

    parameter:link('OpenGL', 'https://learnopengl.com/lighting/basic-lighting')

    parameter:integer('model', 'modelIndex', 1, #models, #models)
    
    parameter:boolean('material', 'materialMode', true)
    parameter:boolean('light', 'lightMode', true)
    parameter:boolean('ambient', 'lightAmbient', true)
    parameter:boolean('diffuse', 'lightDiffuse', true)
    parameter:boolean('specular', 'lightSpecular', true)

    parameter:number('ambientStrength', Bind(lights[2], 'ambientStrength'), 0, 1)
    parameter:number('diffuseStrength', Bind(lights[2], 'diffuseStrength'), 0, 1)
    parameter:number('specularStrength', Bind(lights[2], 'specularStrength'), 0, 1)

    parameter:number('ambientStrength', Bind(materials[1], 'ambientStrength'), 0, 5)
    parameter:number('diffuseStrength', Bind(materials[1], 'diffuseStrength'), 0, 5)
    parameter:number('specularStrength', Bind(materials[1], 'specularStrength'), 0, 3)
    parameter:number('alpha', Bind(materials[1], 'alpha'), 0, 1)

    camera(5, 5, 10)
end

function draw()
    background()
    perspective()

    light(lights)
    
    models[modelIndex].uniforms = {        
        useColor = 1,
        
        useLight = lightMode,
        useLightAmbient = lightAmbient,
        useLightDiffuse = lightDiffuse,
        useLightSpecular = lightSpecular,

        --lights = lights,

        useMaterial = materialMode,
        materials = materials,
    }

    if modelIndex == 1 and models[modelIndex].image == nil then
        -- models[modelIndex].image = Image('resources/images/joconde.png')
    end
    
    models[modelIndex]:draw()
end
