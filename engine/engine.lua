function love.load()
    _, _, W, H = love.window.getSafeArea()    
    love.window.setMode(W, H)

    setupClass()
    unitTesting()
    push2globals(Graphics2d)

    font = love.graphics.newFont(25)

    load()
    
    sketchIndex = 1
    sketch = process[sketchIndex]
end

function love.update(dt)
    sketchIndex = process[(sketchIndex + 1)] and (sketchIndex + 1) or 1
    sketch = process[sketchIndex]

    sketch:updateSketch(dt)
end

function love.draw()
    sketch:drawSketch()

    for _, sketch in ipairs(process) do
        sketch:drawSketch()
    end
end

