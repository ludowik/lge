function setup()
    parameter:action('reset', reset)
    reset()
end

function reset()
        values = Array():forn(W, function ()
       return random() * SIZE / 4
    end)

    thread = coroutine.create(sorting)
end

function update()
    coroutine.resume(thread)
end

function sorting()
    for i=1,W-1 do
        local minIdx = i
        for j=i+1,W do
            if values[j] < values[minIdx] then
                minIdx = j
            end
        end
        if minIdx ~= i then
            values[i], values[minIdx] = values[minIdx], values[i]
        end
        coroutine.yield()
    end
end

function draw()
    background()
    values:foreach(function (v, i)
        rect(i, H/2, 1, -v)
    end)
end