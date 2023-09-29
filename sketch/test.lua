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

    -- local str = ''
    -- for i in index(8) do
    --     str = str..utf8.char(9824+i)
    -- end

    -- fontName('system/arial')

    -- fontSize(64)
    -- textColor(colors.red)
    -- text(fontName())

    -- fontSize(64)
    -- textColor(colors.red)
    -- text(str, 0, 100)

    -- textColor(colors.black)
    -- text(str, 0, 200)
end
