function setup()
    count = 48
    distance = W/2 - 2*X
    step = 0.0
    delta = 0.05/count
end

function draw()
    screenBlur()

    translate(W/2, H/2)

    noStroke()
    fill(Color.hsb(ElapsedTime/10))

    for i=0,count-1 do
        a = (i/count)*TAU

        x = round(cos(a) * distance)
        y = round(sin(a) * distance)

        if i >= count/2 then
            step = step - delta
            
            range = cos(a + step)
            
            x = round(cos(a) * (distance - 1) * range)
            y = round(sin(a) * (distance - 1) * range)

            circle(x, y, 5)
        end
    end
    
end
