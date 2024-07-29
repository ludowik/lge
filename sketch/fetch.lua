function setup()
    actions = Parameter(CENTER)

    ip = getSetting('ip', 13)
    
    actions:integer('ip', 1, 25, 23, function() setSetting('ip', ip) end)
    actions:action('load from ', go)
end

function draw()
    background()
    actions:draw(0, H/2)
end

function mousereleased(x, y)
    actions:mousereleased(x, y)
end

function go()
    return request('http://192.168.1.'..ip..':8080',
        function (result, code, headers)
            message('ok')
        end)
end
