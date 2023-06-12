function love.load()
    sketchIndex = 1
    font = love.graphics.newFont(25)
end

function love.update(dt)
    sketch:update(dt)
end

function love.draw()
    sketch:draw()
end
