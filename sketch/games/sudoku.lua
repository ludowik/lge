function setup()
    grid = Grid(9, 9)

    scene = Scene()
    scene:add(grid)
end

function draw()
    scene:draw()
end
