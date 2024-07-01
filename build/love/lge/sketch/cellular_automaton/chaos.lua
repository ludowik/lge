function setup()
    parameter:integer('configuration', 1, #confs, 1, function ()
            newConf = configuration
        end)

    parameter:boolean('rotation', false) 

    newConf = 1
    reset(newConf)
end

function vector(v)
    return {
        position = v
    }
end

function reset(i)
    background(0)

    conf = confs[i]

    vertices = Array()

    size = min(W, H) / 2

    deltaAngle = TAU / conf.n

    for i = 0,conf.n-1 do
        vertices:add(
            vector(
                vec2(
                    sin(conf.startAngle + i * deltaAngle) * size,
                    cos(conf.startAngle + i * deltaAngle) * size)
            ))
    end

    vertices:chainIt()

    stroke(colors.red)
    strokeSize(10)

    currentPoint = vec2()
    previousPoint = currentPoint
end

function anyPoint()
    return vertices:random()
end

function notPreviousOne()
    local point = previousPoint
    repeat
        randomPoint = vertices:random()
    until randomPoint ~= point
    return randomPoint
end

function notOnePlaceAwayFromThePreviousOne()
    local point = previousPoint.__previous
    repeat
        randomPoint = vertices:random()
    until randomPoint ~= point
    return randomPoint
end

function notTwoPlaceAwayFromThePreviousOne()
    local point = previousPoint.__previous and previousPoint.__previous.__previous
    repeat
        randomPoint = vertices:random()
    until randomPoint ~= point
    return randomPoint
end

confs = {
    {
        n = 3,
        r = 1/2,
        startAngle = 0,
        rule = anyPoint
    },
    {
        n = 4,
        r = 1/2,
        startAngle = TAU/8,
        rule = notPreviousOne
    },
    {
        n = 4,
        r = 1/2,
        startAngle = TAU/8,
        rule = notOnePlaceAwayFromThePreviousOne
    },
    {
        n = 4,
        r = 1/2,
        startAngle = TAU/8,
        rule = notTwoPlaceAwayFromThePreviousOne
    },
    {
        n = 5,
        r = 1/2,
        startAngle = 0,
        rule = notPreviousOne
    },
    {
        n = 5,
        r = 1/3,
        startAngle = 0,
        rule = anyPoint
    },
    {
        n = 5,
        r = 3/8,
        startAngle = 0,
        rule = anyPoint
    },
    {
        n = 6,
        r = 1/3,
        startAngle = 0,
        rule = anyPoint
    }
}

function draw()
    background(0, 0.01)

    if newConf then
        reset(newConf)
        newConf = nil
    end

    stroke(colors.white)
    strokeSize(1)

    translate(CX, CY)

    if rotation then
        rotate(elapsedTime)
    end
    
    for i = 1,1000 do
        local nextPoint = conf.rule()

        currentPoint:sub(nextPoint.position):mul(conf.r):add(nextPoint.position)
        point(currentPoint.x, currentPoint.y)

        previousPoint = nextPoint
    end
end
