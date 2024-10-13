function setup()
    actions = Parameter(CENTER)

    ip = getSetting('ip', 15)
    
    actions:integer('ip', 1, 25, ip, function() setSetting('ip', ip) end)
    actions:action('load from local', function() updateScripts() end)
end

function draw()
    background()
    actions:draw(0, H/2)
end

function mousereleased(x, y)
    actions:mousereleased(x, y)
end
