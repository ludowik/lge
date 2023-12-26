function setup()
    models = Array()

    local directoryItems = love.filesystem.getDirectoryItems('resources/models')
    for _,modelName in ipairs(directoryItems) do
        models:add(Model.load(modelName))
    end

    parameter:link('OpenGL', 'https://learnopengl.com')

    parameter:integer('model', 'modelIndex', 1, #models, 1)
    
    parameter:boolean('light', 'lightMode', true)
    parameter:boolean('ambient', 'lightAmbient', true)
    parameter:boolean('diffuse', 'lightDiffuse', true)
    parameter:boolean('specular', 'lightSpecular', true)

    camera(5, 5, 10)

    lights = {
        Light.ambient(colors.yellow, 0.25),
        Light.random()
    }
end

function draw()
    background()
    perspective()
    
    models[modelIndex].uniforms = {        
        useColor = 1,
        useLight = lightMode,
        useLightAmbient = lightAmbient,
        useLightDiffuse = lightDiffuse,
        useLightSpecular = lightSpecular,

        lights = lights
    }

    if modelIndex == 1 and models[modelIndex].image == nil then
        -- models[modelIndex].image = Image('resources/images/joconde.png')
    end
    
    models[modelIndex]:draw()
end
