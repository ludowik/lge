function setup()
    anchor = Anchor(15)
    grid = Grid(anchor.ni, anchor.nj)
end

function draw() 
    background()

    noStroke()
    fill(colors.white)
    rectMode(CENTER)

    local w = anchor:size(1, 1).x
    grid:foreach(function (cell, i, j)
        local position = anchor:pos(i-1, j-1)
        pushMatrix()
        translate(position.x+w/2, position.y+w/2)
        rotate(ElapsedTime)
        scale(abs(sin(ElapsedTime)))
        rect(0, 0, w-1, w-1)
        popMatrix()
    end)
end
