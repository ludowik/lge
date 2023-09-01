
function setup()    
    angle = 0
    mode = 1

    parameter:link('https://easings.net')

    parameter:integer('mode', 'mode', 1, #functions, 1)
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

    local f = functions[mode]
    seed(12345)

    for j=0,ny-1 do
        translate(0, h)

        pushMatrix()
        for i=0,nx-1 do
            translate(w, 0)

            local clr = Color.random() -- (1 - f() * (j/ny))
            fill(clr)

            pushMatrix()
            do                
                rotate(f() * PI * (j/(ny*2)))
                rect(0, 0, w*0.9, h*0.9)

                textColor(clr:contrast())
                text(('BON ANNIVERSAIRE LOULOU'):random(), 0, 0)
            end
            popMatrix()
        end
        popMatrix()
    end
end

functions = {
    function () return sin(angle) end,
    function () return random() * 2 - 1 end,
    function () return noise(angle) * 2 - 1 end,
    function ()
        return (angle-floor(angle/TAU)*TAU)/TAU
    end,
    function() return easeInSine(angle) end,    
}

function easeInSine(x)
    return 1 - cos((x * PI) / 2)
end

function easeInOutElastic(x)
    local c5 = (2 * PI) / 4.5

    return x == 0
    and 0
    or (x == 1
        and 1
        or (x < 0.5
            and -(pow(2, 20 * x - 10) * sin((20 * x - 11.125) * c5)) / 2
            or (pow(2, -20 * x + 10) * sin((20 * x - 11.125) * c5)) / 2 + 1))
end
