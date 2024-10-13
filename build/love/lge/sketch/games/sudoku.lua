function setup()
    grid = Grid(9, 9)

    --grid.position = vec2(CX, CY) - grid.size/2

    scene = Scene()
    scene:add(grid)

    scene:add(UIButton('1'))
end

function draw()
    scene:draw()
end
