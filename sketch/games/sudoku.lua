function setup()
    grid = Grid(9, 9)

    --grid.position = vec2(W/2, H/2) - grid.size/2

    scene = Scene()
    scene:add(grid)

    scene:add(UIButton('1'))
end

function draw()
    scene:draw()
end
