if getOS() == 'ios' or not love.audio then
    return
end

function setup()    
    devices = love.audio.getRecordingDevices()
    device = devices[1]

    status = 'pause'

    buffer = Array()
    bufferMaxSize = MIN_SIZE

    parameter:watch('#devices')
    parameter:watch('#buffer')
    
    --parameter:watch('status')    
    
    mode = 1
    parameter:integer('mode', 1, 2, 1)
end

function pause()
    status = device:stop()
end

function resume()
    status = device:start(bufferMaxSize)
end

function update(dt)    
    data = device:getData()
    while data do
        for i=0,data:getSampleCount()-1 do
            buffer:add(data:getSample(i))
        end
        data = device:getData()
    end

    while #buffer > bufferMaxSize do
        buffer:remove(1)
    end
end

function draw()
    background(0, 0.1)

    local arrays = Array()

    local size = MIN_SIZE

    local n = #buffer
    local maxValue = math.mininteger
    for i=1,n do
        maxValue = max(maxValue, buffer[i])
    end

    local scale = 1/maxValue
    local function addSample(i)
        if buffer[i] == nil then return end
        
        local len = buffer[i] * scale

        local x, y
        if mode == 1 then
            x = CX + cos(TAU*i/n) * map(len, -1, 1, size/3, size/2)
            y = CY + sin(TAU*i/n) * map(len, -1, 1, size/3, size/2)
        else
            x = i
            y = CY + map(len, -1, 1, -100, 100)
        end

        table.insert(arrays, x)
        table.insert(arrays, y)
    end

    for i=1,n do
        addSample(i)
    end
    
    if mode == 1 then
        addSample(1)
    end

    stroke(colors.white)
    polyline(arrays)
end
