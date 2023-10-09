function draw()
    background(colors.white)

    local x = 0

    textColor(colors.black)

    fontSize(32)

    local directoryItems = love.filesystem.getDirectoryItems('resources/fonts')
    for _,fontRef in ipairs(directoryItems) do
        if fontRef:find('ttf') then
            local name = fontRef:gsub('%.ttf', '')

            fontName(name)
            text(name, x, textPosition())

            if textPosition() > H then
                x = x + Anchor(4):size(1,1).x
                textPosition(0)
            end
        end
    end 

    translate(0, 350)

    local str = 'Suite '
    str = str..utf8.char(9824+0)
    ..utf8.char(9824+3)
    ..utf8.char(9824+5)
    ..utf8.char(9824+6)

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
