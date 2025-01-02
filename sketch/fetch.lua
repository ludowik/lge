function setup()
    actions = Parameter(CENTER)

    ip = getSetting('ip', 32)
    
    actions:integer('ip', 1, 32, ip, function() setSetting('ip', ip) end)
    actions:action('load from local', function() updateScripts(false) end)

    actions:space()
    
    actions:action('load from git', function() updateScripts(true) end)
end

function draw()
    background()
    actions:draw(0, H/2)
end

function mousereleased(x, y)
    actions:mousereleased(x, y)
end
