local size = 30
local N, M = 15, 30

function draw()
    for i = 1, N, 1 do
        for j = 1, M, 1 do
            pushMatrix()
            translate(i*size, j*size)
            draw_geometry()
            popMatrix()
        end
    end
end

function draw_geometry()
    rect(0, 0, size, size)
end
