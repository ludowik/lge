function setup()
    local anchor = Anchor(32)
    size = anchor:size(1, 1).x
    m = ceil(anchor.ni/2)
    n = ceil(anchor.nj/2)
end

function draw()
    translate(CX, CY)
    
    for j = -n,n do
        pushMatrix()
        translate((-m+0.5)*size, (j+0.5)*size)
        for i = -m,m do
            draw_geometry(i, j)
            translate(size, 0)
        end
        popMatrix()
    end
end

function draw_geometry(i, j)
    fill(Color(noise(i*0.1, j*0.1, elapsedTime)))
    noStroke()
    rectMode(CENTER)
    rect(0, 0, size-2, size-2, 32*random())
end
