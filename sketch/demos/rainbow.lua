Rainbow = class() : extends(Sketch)

function Rainbow:init()
    Sketch.init(self)
end

function Rainbow:draw()
    local w = H / 4
    local h = H / 4

    background(colors.gray)

    local CX, CY = W/2, H/2

    -- lines
    pushMatrix()
    do
        translate(CX, 0)
        strokeSize(1)
        for hue=0,w-1 do
            stroke(Color.hsb(hue / w))
            line(hue - w / 2, 0, hue - w / 2, h)
        end
    end
    popMatrix()

    -- circle
    pushMatrix()
    do
        translate(CX, h + h / 2)
        noStroke()
        rotate(-PI / 2)
        for hue=0,w-1 do
            fill(Color.hsb(hue / w, 0.5, 0.5))
            arc(0, 0, h/2, h/2,
                TAU * hue / w,
                TAU * (hue + 1) / w)
        end
    end
    popMatrix()

    -- point
    pushMatrix()
    do
        translate(CX / 2, h * 2)
        strokeSize(2)
        rectMode(CORNER)
        for hue=0,w-1 do
            for saturation=0,w-1 do
                fill(Color.hsb(hue / w, saturation / w, 0.5))
                rect(hue, saturation, 1, 1)
            end
        end
    end
    popMatrix()

    -- ring
    pushMatrix()
    do
        translate(CX, h * 3 + h / 2)
        noStroke()
        rotate(-PI / 2)
        local d = 256 / 24
        for r=w/2,1,-d*2 do
            for hue=0,w-1,d do
                fill(Color.hsb(hue / w, r / w, r / w))
                arc(0, 0, r, r,
                    TAU * hue / w,
                    TAU * (hue + d) / w)
            end
        end
    end
    popMatrix()
end
