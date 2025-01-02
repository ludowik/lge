function setup()
    models = Array()
    
    local directoryItems = love.filesystem.getDirectoryItems('resources/models')
    for _,modelName in ipairs(directoryItems) do
        local model = Model.load(modelName)
        if model then
            model.vertices = Model.normalize(Model.centerVertices(model.vertices))
            models:add(model)
        end
    end
    
    lights = {
        Light.sun()
    }

    materials = {
        materials.wood
    }

    parameter:link('OpenGL', 'https://learnopengl.com/lighting/basic-lighting')
    parameter:link('Models', 'https://poly.pizza')

    parameter:integer('model index', 'modelIndex', 1, #models, 1)
    parameter:watch('model', 'models[modelIndex].fileName')
    
    parameter:boolean('material', 'materialMode', false)
    parameter:boolean('texture', 'withTexture', false)

    parameter:boolean('light', 'lightMode', true)
    parameter:boolean('ambient', 'lightAmbient', true)
    parameter:boolean('diffuse', 'lightDiffuse', true)

    parameter:boolean('specular', 'lightSpecular', true)

    parameter:number('light - ambient', Bind(lights[1], 'ambientStrength'), 0, 1)
    parameter:number('light - diffuse', Bind(lights[1], 'diffuseStrength'), 0, 1)
    parameter:number('light - specular', Bind(lights[1], 'specularStrength'), 0, 1)

    parameter:number('material - ambient', Bind(materials[1].ambientColor, 'r'), 0, 5)
    parameter:number('material - diffuse', Bind(materials[1].diffuseColor, 'r'), 0, 5)
    parameter:number('material - specular', Bind(materials[1].specularColor, 'r'), 0, 3)
    parameter:number('alpha', Bind(materials[1], 'shininess'), 0, 1)

    camera(3, 2, 3)
end

function draw()
    local model = models[modelIndex]

    background()
    
    perspective()

    light(lights)
    
    model.uniforms = {        
        useColor = true,
        
        useLight = lightMode,
        useLightAmbient = lightAmbient,
        useLightDiffuse = lightDiffuse,
        useLightSpecular = lightSpecular,

        useMaterial = materialMode,
        materials = materials,
    }

    if withTexture then
        model.image = model.image or model.__image or image('joconde.png')
    else
        model.__image = model.__image or model.image
        model.image = nil
    end

    model:draw()
end
