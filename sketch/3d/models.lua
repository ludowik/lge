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
end

function draw()
    background()
    perspective()

    camera(5, 5, 10)
    
    models[modelIndex].uniforms = {
        matrixModel = {modelMatrix():getMatrix()},
        matrixPV = {pvMatrix():getMatrix()},
        
        useLight = lightMode,
        useLightAmbient = lightAmbient,
        useLightDiffuse = lightDiffuse,        
    }
    models[modelIndex]:draw()
end
