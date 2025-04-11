function setup()
    parameter:number('size', 1, 10, 1)
    parameter:number('linesCount', 10000, 100000, 10000, function ()
        linesArray = Array()
        for i in range(linesCount) do
            linesArray:add{random(W), random(H), random(W), random(H), Color.random()}
        end
    end)
end

function draw()
    background(colors.black)

    strokeSize(size)

    for i,l in ipairs(linesArray) do
        -- stroke(l[5])
        -- line(l[1], l[2], l[3], l[4])
    end

    lines(linesArray)
end
