function setup()
    nextValue = 1
    value = nextValue

    angle = 0
    x1, y1, x2, y2 = 0, 0, 0, 0

    rotation = PI / 1.99

    len = min(W, H) / 15

    clr = Color.random()
    clr.a = 0.1

    parameter:number('rotation', 0, TAU, rotation, function (value)
            nextValue = 1
        end)

    parameter:integer('len', SIZE/10, SIZE, 50, function ()
            nextValue = 1
        end)
end

function collatz()    
    if value == 1 then
        nextValue = nextValue + 1
        value = nextValue

        clr = Color.random()
        clr.a = 0.1

        angle = 0
        x1, y1, x2, y2 = 0, 0, 0, 0
    end

    if value % 2 == 0 then
        -- even
        value = value / 2
        angle = angle - rotation

    else
        -- odd
        value = (3 * value + 1) / 2
        angle = angle + rotation
    end

    x1, y1 = x2, y2

    x2 = x2 + cos(angle) * len
    y2 = y2 + sin(angle) * len

    strokeSize(2)
    stroke(clr)

    line(x1, y1, x2, y2)
end

function draw()
    if nextValue == 1 then
        background(0)
    else
        background(0, 0, 0, 0.01)
    end
    
    translate(CX, CY)

    for i=1,10 do
        collatz()
    end
end
