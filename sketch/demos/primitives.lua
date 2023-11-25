function setup()
    background(120)
    parameter:watch('N')
    N = 0
end

function draw()
    if ElapsedTime * 1000 / 30 < N then return end
    screenBlur(0, 0.05)

    noFill()

    local attributes = {
        position = vec2.randomInScreen(),
        size = vec3.random():normalizeInPlace(100),
        width = random(1, 10),
        rotation = random(360)
    }

    primitive(attributes)
    N = N + 1
end

local primitives = {
    function (attributes)
        local position, size, width, rotation = attributes.position, attributes.size, attributes.width, attributes.rotation
        strokeSize(width)
        point(0, 0)
    end,
    function (attributes)
        local position, size, width, rotation = attributes.position, attributes.size, attributes.width, attributes.rotation
        line(0, 0, size.x, size.y)
    end,
    function (attributes)
        local position, size, width, rotation = attributes.position, attributes.size, attributes.width, attributes.rotation
        rectMode(CENTER)
        rect(0, 0, size.x, size.y)
    end,
    function (attributes)
        local position, size, width, rotation = attributes.position, attributes.size, attributes.width, attributes.rotation
        circleMode(CENTER)
        circle(0, 0, size.x)
    end,
    function (attributes)
        local position, size, width, rotation = attributes.position, attributes.size, attributes.width, attributes.rotation
        ellipseMode(CENTER)
        ellipse(0, 0, size.x, size.y)
    end
}

function primitive(attributes)
    local i = randomInt(1, #primitives)

    if attributes.position then
        translate(attributes.position.x, attributes.position.y)
    end

    if attributes.rotation then
        rotate(attributes.rotation)
    end

    fill(Color.random())

    strokeSize(randomInt(6))
    stroke(Color.random())

    primitives[i](attributes)
end
