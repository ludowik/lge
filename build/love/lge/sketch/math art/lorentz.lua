local x = 0.01
local y = 0
local z = 0

local a = 10
local b = 28
local c = 8.0 / 3.0

points = Array()

function setup()
    parameter:watch('#points')
    target = vec3()
end

local function step(dt)
    local dx = (a * (y - x)) * dt
    local dy = (x * (b - z) - y) * dt
    local dz = (x * y - c * z) * dt

    x = x + dx
    y = y + dy
    z = z + dz

    points:add(vec3(x, y, z))
end

function update(dt)
    for i = 1,100 do
        step(dt/10)
    end
end

function draw()
    background()

    perspective()
    --scale(2/W)

    -- translate(CX, CY)
    -- scale(4, 4)
    
    strokeSize(0.1)
    stroke(colors.blue)
    
    noFill()
    
    local camX = map(mouse.position.x, 0, W, -200, 200)
    local camY = map(mouse.position.y, 0, H, -200, 200)

--    camera(vec3(camX, camY, -(H / 2.0) / tan(PI * 30.0 / 180.0)), target)
    camera(vec3(2, 2, -5), target)

    strokeSize(1/15)
    scale(1/15)

    stroke(colors.white)
    
    if #points <3 then return end

    local hu = 0
    
    target = vec3()

    beginShape()
    for i,v in ipairs(points) do
        stroke(Color.hsl(hu, 1, 1))
        
        vertex(v.x, v.y, v.z)

        target = target + v

        hu = hu + 1

        if hu > 255 then
            hu = 0
        end
    end
    endShape()

    target = target / #points
end
