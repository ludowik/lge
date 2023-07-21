function setup()
    size = 4
    grid = Grid(W/size, H/size)

    position = vec2(grid.w/2, grid.h/2):floor()    
    direction = vec2(0, 1)

    parameter:watch('position', 'env.position')
    parameter:watch('direction', 'env.direction')
end

function step()
    local value = grid:get(position.x, position.y) 

    if value == true then
        direction = vec2(direction.y, -direction.x)
        fill(colors.black)
    else
        direction = vec2(-direction.y, direction.x)
        fill(colors.white)
    end
    rect(position.x*size, position.y*size, size, size)
    
    grid:set(position.x, position.y, not value)
    
    position = position + direction
end

function draw()
    noStroke()
    rectMode(CENTER)
    
    for i=1,10 do
        step()
    end
end
