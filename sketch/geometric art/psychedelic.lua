function setup()
    --noLoop()
    s = time()

    params = {
        strokeSize = {25, 1, 50},
    }

    for name,v in pairs(params) do
        if type(v[1]) == 'number' then
            params[name] = v[1]
            parameter:integer(name, Bind(params, 'strokeSize'), v[2] or 0, v[3] or 100)
        end
    end
end

function draw()
    background()

    translate(CX, CY)

    local function circle(r)
        local a = 0
        local b = 0

        seed(r)

        local angle = random(-PI, PI)
        rotate(sign(angle)*elapsedTime*.05)

        strokeSize(random(params.strokeSize))
        while a < TAU do
            b = a + random(PI/4)
            stroke(Color(random()))
            arc(0, 0, r, a, b, 2)
            a = b + 0.15
        end
    end

    local r, d = 5, 10
    while r < MAX_SIZE do
        circle(r)
        r = r + d
        d = (MAX_SIZE*4 - r) / MAX_SIZE
    end
end

