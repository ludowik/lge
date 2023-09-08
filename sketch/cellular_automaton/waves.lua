function setup()
    scale = 0.5

    sizeW = even(W * 0.5)
    sizeH = even(H * 0.5)

    buf1 = Buffer('float'):resize(sizeW*sizeH)
    buf2 = Buffer('float'):resize(sizeW*sizeH)

    damping = 0.95

    img = FrameBuffer(sizeW, sizeH)
    img:background()
end

function update(dt)
    for i=1,2 do
        step()
    end

    waterDrop(randomInt(sizeW), randomInt(sizeH))
end

function step()
    local index, offset, value, brigthness

    index = getOffset(2, 2-1)

    for y=2,sizeH-1 do        
        for x=2,sizeW-1 do
            value = (
                buf1[index-1] +
                buf1[index+1] +
                buf1[index-sizeW] +
                buf1[index+sizeW]
                ) * 0.5 - buf2[index]

            value = value * damping

            buf2[index] = value

            brigthness = 128 + value * 128

            offset = (index -1) * 4

            img:set(x, y, brigthness, brigthness, brigthness)

            index = index + 1
        end

        index = index + 2
    end

    buf1, buf2 = buf2, buf1
end

function getOffset(x, y)
    return round(x) + round(y) * sizeW
end

function draw()
    background()

    spriteMode(CORNER)
    sprite(img, 0, 0)

    noFill()

    rectMode(CORNER)
    rect(0, 0 , sizeW, sizeH)
end

function mousereleased(touch)
    waterDrop(touch.position.x, touch.position.y)
end

function waterDrop(x, y, h)
    local offset = getOffset(x, y)
    buf1[offset] = h or random(100, 1000)
end
