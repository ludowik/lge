function setup()
    lastKey = ''
end

function keypressed(key)
    lastKey = key
end

function draw(key)
    background()
    textMode(CENTER)
    text(lastKey, CX, CY)
end