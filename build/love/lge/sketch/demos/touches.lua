local t1, t2, distance
function draw()
    background()

    circleMode(CENTER)

    noStroke()
    fill(colors.red)

    if t1 then circle(t1.x, t1.y, 25) end
    if t2 then circle(t2.x, t2.y, 25) end

    if distance then text(distance) end
end

function touchzoomed(_t1, _t2, _distance)
    t1, t2, distance = _t1, _t2, _distance
end

local function getTouch(id)
    local x, y = love.touch.getPosition(id)
    return vec2(x, y)
end

function setup()
    local t1, t2, currentDistance, newDistance

    local touchpressed = love.touchpressed
    function love.touchpressed(id, x, y, dx, dy, pressure)
        touchpressed(id, x, y, dx, dy, pressure)

        local touches = love.touch.getTouches()
        if #touches == 2 then
            t1 = getTouch(touches[1])
            t2 = getTouch(touches[2])
            firstDistance = (t1-t2):len()
        end
    end

    local touchmoved = love.touchmoved
    function love.touchmoved(id, x, y, dx, dy, pressure)
        touchmoved(id, x, y, dx, dy, pressure)

        local touches = love.touch.getTouches()
        if #touches == 2 then
            t1 = getTouch(touches[1])
            t2 = getTouch(touches[2])
            currentDistance = (t1-t2):len()

            touchzoomed(t1, t2, currentDistance-firstDistance)
        end
    end

    local touchreleased = love.touchreleased
    function love.touchreleased(id, x, y, dx, dy, pressure)
        touchreleased(id, x, y, dx, dy, pressure)

        touchzoomed()
    end
end
