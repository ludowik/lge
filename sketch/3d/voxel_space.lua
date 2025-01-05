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
        zFar = 350, -- how far i can see
        fov = 45, -- field of view
    }

    w, h = 320, 200
    img = FrameBuffer(w, h)

    --map = MapCache('map0')
    map = MapNoise()

    SCALE = MIN_SIZE/1024/2
end

function click()
    camera.position = mouse.position / SCALE
    camera.z = map:getHeight(camera.position.x, camera.position.y) + 50
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

    camera.z = map:getHeight(camera.position.x, camera.position.y) + 50
end

function draw()
    background()

    scale(SCALE)

    if map.color then
        sprite(map.color)
        sprite(map.height, 0, 1024)
    end

    stroke(colors.green)
    strokeSize(30)
    point(camera.position.x, camera.position.y)
    point(camera.position.x, camera.position.y+1024)

    render()
end

function render()
    strokeSize(1)

    local pl = vec2( camera.zFar, camera.zFar)
    local pr = vec2(-camera.zFar, camera.zFar)

    local dir = pr - pl

    img:background()

    img:getImageData()

    local pointsList = Array()
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

            local clr, xx, yy = map:getColor(rx, ry)
            if clr then

                local height = (camera.z - map:getHeight(rx, ry)) / z * 100.  + camera.horizon
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

            pointsList:add(xx)
            pointsList:add(yy)
        end
    end

    stroke(0, 1, 0, 1)
    points(pointsList)

    translate(size, size/2)
    scale(4, 4)

    sprite(img)
end

Map = class()

function Map:init(filename)
    self.color = Image('resources/images/'..filename..'.color.png')
    self.height = Image('resources/images/'..filename..'.height.png')
    self.size = self.color.width
end

function Map:getOffset(x, y)
    local size = self.size

    while x < 0 do x = x + ceil(abs(x)/size)*size end
    x = x % size

    while y < 0 do y = y + ceil(abs(y)/size)*size end
    y = y % size
    
    return floor(x) + floor(y) * size, x, y
end

function Map:getColor(x, y)
    local offset, x, y = self:getOffset(x, y)
    local r, g, b, a = self.color:getPixel(x, y)
    return {r, g, b, a}, x, y
end

function Map:getHeight(x, y)
    local offset, x, y = self:getOffset(x, y)
    local r, g, b, a = self.height:getPixel(x, y)
    return r*256, x, y
end


MapCache = class() : extends(Map)

function MapCache:init(filename)
    Map.init(self, filename)
    
    self.colorMap = {}
    self.heightMap = {}
    for y = 0,size-1 do
        local yy = y * size
        for x = 0,size-1 do
            self.colorMap[x + yy] = {
                self.color:getPixel(x, y)
            }

            self.heightMap[x + yy] = self.height:getPixel(x, y) * 256
        end
    end
end

function MapCache:getColor(x, y)
    local offset, x, y = self:getOffset(x, y)
    return self.colorMap[offset], x, y
end

function MapCache:getHeight(x, y)
    local offset, x, y = self:getOffset(x, y)
    return self.heightMap[offset], x, y
end


MapNoise = class() : extends(Map)

function MapNoise:init(filename)
    self.size = 1024
end

function MapNoise:getColor(x, y)
    local offset, x, y = self:getOffset(x, y)
    local n = noise(x/100, y/100) 
    return {n, n, n}
end

function MapNoise:getHeight(x, y)
    local offset, x, y = self:getOffset(x, y)
    return noise(x/100, y/100) * 30
end