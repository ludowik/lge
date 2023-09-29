function draw()
    background(colors.white)

    local str = ''
    for i in index(8) do
        str = str..utf8.char(9824+i)
    end

    fontName('arial')

    fontSize(64)
    textColor(colors.red)
    text(fontName())

    fontSize(64)
    textColor(colors.red)
    text(str, 0, 100)

    textColor(colors.black)
    text(str, 0, 200)
end
