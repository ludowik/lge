function setup()
    resize()
end

function resize()
    ratio = 0.25

    sizeW = even(W * ratio) + 4
    sizeH = even(H * ratio) + 4
    
    buf1 = Buffer('float'):resize(sizeW*sizeH)
    buf2 = Buffer('float'):resize(sizeW*sizeH)

    damping = 0.95

    img = FrameBuffer(sizeW, sizeH)
    img:background(colors.red)
end

function update()
    step()

    if random() >= 0.99 then
        waterDrop(randomInt(sizeW), randomInt(sizeH))
    end
end

function step()
    local index = getOffset(2, 2-1)

    for y=2,sizeH-1 do        
        for x=2,sizeW-1 do
            local value = (( 
                buf1[index-1] +
                buf1[index+1] +
                buf1[index-sizeW] +
                buf1[index+sizeW]
                ) * 0.5 - buf2[index]) * damping

            buf2[index] = value

            local brigthness = (1-value)
            img:setPixel(x-1, y-1, brigthness, brigthness, brigthness, brigthness)

            index = index + 1
        end

        index = index + 2
    end

    buf1, buf2 = buf2, buf1
end

function getOffset(x, y)
    return x + y * sizeW
end

function draw()
    background()

    scale(1/ratio)
    translate(-1, -1)

    spriteMode(CORNER)
    sprite(img)
end

function mousereleased(touch)
    waterDrop(touch.position.x*ratio, touch.position.y*ratio)
end

function waterDrop(x, y, h)
    local offset = getOffset(round(x), round(y))
    buf1[offset] = h or random(100, 1000)
end
