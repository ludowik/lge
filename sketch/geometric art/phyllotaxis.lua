function setup()    
    parameter:link('CodingChallenges #30', 'https://thecodingtrain.com/tracks/algorithmic-botany/30-phyllotaxis')    

    parameter:integer('spacing', 2, 20, 4)
    parameter:number('theta', 130, 145, 137.5)

    local function setTheta(ui)
        theta = tonumber(ui.label)
        n = 0
    end

    parameter:action('137.3', setTheta)
    parameter:action('137.5', setTheta)
    parameter:action('137.7', setTheta)

    n = 0
end

local cos, sin, deg, rad, sqrt = math.cos, math.sin, math.deg, math.rad, math.sqrt

function draw()
    background(51)

    translate(W/2, H/2)
    rotate(rad(n/10))

    local size = spacing - 1

    for i=0,n-1 do
        local radius = spacing * sqrt(i)

        local angle = i * rad(theta)

        local x = radius * cos(angle)
        local y = radius * sin(angle)

        strokeSize(size*2)
        stroke(Color.hsl(((deg(angle)-radius)%360)/360, 1, 0.5))

        point(x, y)
    end

    n = n + 10
end
