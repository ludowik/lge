
function setup()    
    angle = 0
    mode = 1
end

function update(dt)
    angle = angle + dt
end

function draw()
    background()

    local nx = 10
    local w = round(W / (nx + 2))
    local h = w * 1.2
    local ny = round(H / h) - 2

    fontSize(18)

    textMode(CENTER)
    rectMode(CENTER)

    translate(w/2, w/2)

    strokeSize(0.1)
    stroke(colors.black)

    seed(12345)

    for j=0,ny-1 do
        translate(0, h)

        pushMatrix()
        for i=0,nx-1 do
            translate(w, 0)

            local clr = Color.random():grayscale()
            fill(clr)

            pushMatrix()
            do
                translate(
                    random(-w/2, w/2) * ((j/ny)^4),
                    random(-w/2, w/2) * ((j/ny)^4))

                rotate(random(-PI/2, PI/2) * (j/ny)^2)

                rect(0, 0, w*0.9, h*0.9)

                textColor(clr:contrast())
                text(('SCHOTTER'):random(), 0, 0)
            end
            popMatrix()
        end
        popMatrix()
    end
end
