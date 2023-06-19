function love.load()
    sketchIndex = 1
    sketch = sketches[sketchIndex]

    font = love.graphics.newFont(25)

    push2globals(Graphics2d)

    _, _, W, H = love.window.getSafeArea()    
    love.window.setMode(W, H)
end

function love.update(dt)
    sketchIndex = sketches[(sketchIndex + 1)] and (sketchIndex + 1) or 1
    sketch = sketches[sketchIndex]

    sketch:updateSketch(dt)
end

function love.draw()
    sketch:drawSketch()
end

