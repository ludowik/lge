function setup()
    background(colors.red)
    startValue = time()
end

function draw()
    background(1, 1, 1, 0.6)

    circleMode(CENTER)

    drawCircles(1, 0.25)
    drawCircles(2, 0.2)
    drawCircles(20)
end

function drawCircles(n, a)
    local w = ceil(H / (n+1))

    local xscale = 45.123
    local yscale = 54.987

    for x = 0, 2 + n * (W / H) do
        for y = 0, n + 1 do
            local noiseValue = noise(x*xscale, y*yscale)
            local radius = w / 2 * sin(ElapsedTime + noiseValue + startValue)

            local hue = 0.5 + cos(ElapsedTime / 10 * noiseValue) / 2

            fill(Color.hsl(1-hue, 0.25, 0.5, a))
            
            strokeSize((sin(ElapsedTime * noiseValue) + 1) * radius / 8)
            stroke(Color.hsl(hue, 0.5, 0.5, a))
            
            circle(x*w, y*w, abs(radius))
        end
    end
end
