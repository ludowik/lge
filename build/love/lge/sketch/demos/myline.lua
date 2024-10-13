function setup()
    parameter:number('size', 1, 10, 1)
    parameter:number('linesCount', 10000, 100000, 10000, function ()
        lines = Array()
        for i in range(linesCount) do
            lines:add{random(W), random(W), random(W), random(W), Color.random()}
        end
    end)
end

function draw()
    background(colors.black)

    strokeSize(size)

    for i,l in ipairs(lines) do
        -- stroke(l[5])
        -- line(l[1], l[2], l[3], l[4])
    end

    mylines(lines)
end
