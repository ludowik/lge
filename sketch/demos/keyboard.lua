function setup()
    lastKey = ''
end

function keypressed(key)
    lastKey = key
end

function draw(key)
    background()
    textMode(CENTER)
    text(lastKey, W/2, H/2)
end