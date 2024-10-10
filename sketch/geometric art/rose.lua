function setup()
    marge = 10

    diameter = (min(W, H) - marge) / 9
    radius = diameter / 2.5
    
    roses = {}

    m = 1
    n = 1
end

function draw()
    background(51)

    translate(CX, CY)

    stroke(colors.gray)

    line(-W, 0, W, 0)
    line(0, -H, 0, H)

    stroke(colors.white)

    fontSize(10)
    textMode(CENTER)

    for m = 1,9 do
        local x = radius + diameter * (m-1) - (9 * diameter) / 2

        for n = 1,9 do
            local y = radius + diameter * (n-1) - (9 * diameter) / 2

            noFill()
            
            if roses[m..n] then
                roses[m..n]:draw()
            else
                noFill()
                beginShape()
                for angle = 0, TAU * n, 0.15 do
                    local r = radius * cos(angle * m / n)
                    vertex(
                        x + r * cos(angle),
                        y + r * sin(angle))
                end
                roses[m..n] = endShape(CLOSE)
            end

            textColor(colors.white)
            text(string.format('%.2f', m/n), x, y + diameter/2)
        end
    end
end
