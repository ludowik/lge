function setup()
    models = Array()

    local directoryItems = love.filesystem.getDirectoryItems('resources/models')
    for _,modelName in ipairs(directoryItems) do
        models:add(Model.load(modelName))
    end

    parameter:integer('model', 'modelIndex', 1, #models, 1)
end

function draw()
    background()
    perspective()

    camera(5, 5, 10)
    
    models[modelIndex]:draw()
end
