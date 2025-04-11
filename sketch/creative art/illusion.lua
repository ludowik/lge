function setup()
    count = 48
    distance = SIZE / 2
    step = 0.0
    delta = 0.05/count
end

function draw()
    background(0, 0.05)

    translate(CX, CY)

    noStroke()

    for i=0,count-1 do
        a = (i/count)*TAU

        x = round(cos(a) * distance)
        y = round(sin(a) * distance)

        fill(Color.hsb(i/count))

        if i >= count/2 then
            step = step - delta
            
            range = cos(a + step)
            
            x = round(cos(a) * (distance - 1) * range)
            y = round(sin(a) * (distance - 1) * range)

            circle(x, y, 5)
        end
    end
end
