function setup()
    noLoop()
end

function draw()
    background(colors.white)

    fontSize(180)
    textColor(colors.blue)
    textMode(CENTER)
    text('LGE', CX, CY)

    captureLogo()
end