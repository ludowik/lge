function setup()
    parameter:number('size', 1, 10, 1)

    lines = Array()
    for i in range(20000) do
        lines:add{random(W), random(W), random(W), random(W), Color.random()}
    end
end

function draw()
    background(colors.black)

    strokeSize(size)

    for i,l in ipairs(lines) do
        stroke(l[5])
--        line(l[1], l[2], l[3], l[4])
    end

    mylines(lines)
end
