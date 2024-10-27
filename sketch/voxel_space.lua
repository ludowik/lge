-- TODO : Fixing the zFar clipping plane
-- One common approach to reduce the aggressive zFar clip at the  distance is a fog effect

-- TODO : Camera roll (tilting effect left/right)
-- To simultate camera leaning

-- TODO : Use sprites for enemies, , missiles, and other objects on top of the terrain

function setup()
    size = 1024
    camera = {
        position = vec2(size/2, size/2),
        z = 150,
        horizon = 50,
        angle = PI,
        tilt = 1.5,
        zFar = 250, -- how far i can see
        fov = 45, -- field of view
    }

    w, h = 320, 200
    img = FrameBuffer(w, h)

    colorsImage = Image('resources/images/map0.color.png')
    heightImage = Image('resources/images/map0.height.png')

    colorsMap = {}
    heightMap = {}
    for y = 0,size-1 do
        local yy = y * size
        for x = 0,size-1 do
            colorsMap[x + yy] = {
                colorsImage:getPixel(x, y)
            }

            heightMap[x + yy] = heightImage:getPixel(x, y) * 256
        end
    end

    SCALE = MIN_SIZE/1024/2
end

function click()
    camera.position = mouse.position / SCALE

    local offset = getOffset(camera.position.x, camera.position.y)
    camera.z = heightMap[offset] + 50
end

function mousemoved(mouse)
    camera.angle = camera.angle + mouse.deltaPos.x / 10
end

function update(key)
    camera.tilt = 0
    camera.horizon = 50

    if love.keyboard.isDown('up') then
        camera.position:add(vec2(0, 2):rotateInPlace(camera.angle))
        camera.horizon = 20
    end
    if love.keyboard.isDown('down') then
        camera.position:add(vec2(0, -2):rotateInPlace(camera.angle))    
        camera.horizon = 70
    end
    if love.keyboard.isDown('left') then        
        camera.angle = camera.angle - 0.05
        camera.tilt = 1.5
    end
    if love.keyboard.isDown('right') then
        camera.angle = camera.angle + 0.05
        camera.tilt = -1.5
    end
    if love.keyboard.isDown('q') then
        camera.horizon = camera.horizon + 5
    end
    if love.keyboard.isDown('w') then
        camera.horizon = camera.horizon - 5
    end

    local offset = getOffset(camera.position.x, camera.position.y)
    camera.z = heightMap[offset] + 50
end

function draw()
    background()

    scale(SCALE)

    sprite(colorsImage)
    sprite(heightImage, 0, 1024)

    stroke(colors.green)
    strokeSize(30)
    point(camera.position.x, camera.position.y)
    point(camera.position.x, camera.position.y+1024)

    render()
end

function getOffset(x, y)
    while x < 0 do x = x + ceil(abs(x)/size)*size end
    x = x % size

    while y < 0 do y = y + ceil(abs(y)/size)*size end
    y = y % size
    
    return floor(x) + floor(y) * size, x, y
end

function render()
    strokeSize(1)

    local pl = vec2( camera.zFar, camera.zFar)
    local pr = vec2(-camera.zFar, camera.zFar)

    local dir = pr - pl

    img:background()

    img:getImageData()

    for x=0,w-1 do
        local lean = (camera.tilt * (x / w - 0.5) + 0.5) * h / 6

        local delta = (pl + (dir) / w * x) / (camera.zFar)
        delta:rotateInPlace(camera.angle)

        local rx = camera.position.x
        local ry = camera.position.y
        
        local maxHeight = h

        for z=0,camera.zFar-1 do
            rx = rx + delta.x
            ry = ry + delta.y

            local offset, xx, yy = getOffset(rx, ry)

            local clr = colorsMap[offset]
            if clr then

                local height = (camera.z - heightMap[offset]) / z * 100.  + camera.horizon
                if height < maxHeight then
                    height = floor(clamp(height, 0, maxHeight))
                    for y=height+lean,maxHeight+lean-1 do
                        if y >= 0 and y < h then
                            img:setPixel(x, y, clr[1], clr[2], clr[3])
                        end
                    end
                    maxHeight = height
                end

            end

            stroke(0, 1, 0, 1)
            point(xx, yy)
        end
    end

    translate(size, size/2)
    scale(4, 4)

    sprite(img)
end
