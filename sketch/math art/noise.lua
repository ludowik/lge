function setup()
    start = 0

    img = FrameBuffer(W, H)

    parameter:number('frequency', 1, 100, 50,
        function ()
            generateImg()
        end)

    parameter:number('amplitude', 0, 2, 1,
        function ()
            generateImg()
        end)
end

function release()
    img:release()
end

function generateImg()
    if img.width ~= W then
        img:release()
        img = FrameBuffer(W, H)
    end
    
    local r
    for x=0,W-1 do
        for y=0,H-1 do
            r = noise(
                x / frequency,
                y / frequency)

            img:setPixel(x, y, r, r, r, 1)
        end
    end
end

function update(dt)
    start = start + 2
end

function draw()
    background()

    spriteMode(CORNER)
    sprite(img, 0, 0)

    local y = H / 2
    local h = 100 * amplitude

    noFill()

    beginShape()
    for x=0,W do
        vertex(x, y + noise((start+x)/frequency)*h)
    end
    endShape()

    stroke(colors.red)
    line(0, y, W, y)

    stroke(colors.blue)
    line(0, y+h, W, y+h)

    line(W /2, 0, W / 2, H)
end
