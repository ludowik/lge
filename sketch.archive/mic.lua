function setup()
    devices = love.audio.getRecordingDevices()
    device = devices[1]

    status = device:start(8000)

    buffer = Array()

    parameter:watch('#devices')
    parameter:watch('status')
    parameter:watch('#buffer')
    
    mode = 2
    parameter:integer('mode', 'mode', 1, 2, 1)
end

function pause()
    status = device:stop()
end

function resume()
    status = device:start(2048)
end

function update(dt)
    data = device:getData()
    while data do
        for i=0,data:getSampleCount()-1 do
            buffer:add(data:getSample(i))
        end
        data = device:getData()
    end

    while #buffer > W do
        buffer:remove(1)
    end
end

function draw()
    background()

    local arrays = Array()

    local size = min(W, H) 

    local n = #buffer
    local maxValue = math.mininteger
    for i=1,n do
        maxValue = max(maxValue, buffer[i])
    end

    local scale = 1/maxValue
    for i=1,n do
        local len = buffer[i] * scale

        local x, y
        if mode == 1 then
            x = W/2 + cos(TAU*i/n) * map(len, -1, 1, size/3, size/2)
            y = H/2 + sin(TAU*i/n) * map(len, -1, 1, size/3, size/2)
        else
            x = i
            y = H/2 + map(len, -1, 1, -100, 100)
        end

        table.insert(arrays, x)
        table.insert(arrays, y)
    end

    polygon(arrays)
end
