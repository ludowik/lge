function setup()
    lastKey = ''
end

function resume()
    love.keyboard.setTextInput(true)
end

function pause()
    love.keyboard.setTextInput(false)
end

function keypressed(key)
    lastKey = key
end

function draw(key)
    background()
    textMode(CENTER)
    text(lastKey, CX, CY)
end