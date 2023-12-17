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
end

Light = class()

function Light:init(lightColor, ambientStrength, diffuseStrength, specularStrength)
    self.lightColor = lightColor
    self.ambientStrength = ambientStrength
    self.diffuseStrength = diffuseStrength
    self.specularStrength = specularStrength
end

function draw()
    background()
    perspective()
    
    local light = Light(Color(.8, .6, .6, 1.), .8, .8, 0.8)

    models[modelIndex].uniforms = {
        matrixModel = {modelMatrix():getMatrix()},
        matrixPV = {pvMatrix():getMatrix()},
        
        useColor = 1,
        useLight = lightMode,
        useLightAmbient = lightAmbient,
        useLightDiffuse = lightDiffuse,
        useLightSpecular = lightSpecular,
    }
    models[modelIndex]:draw()
end
