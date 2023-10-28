function setup()
    fonts = Array()

    local directoryItems = love.filesystem.getDirectoryItems('resources/fonts')
    for _,fontRef in ipairs(directoryItems) do
        if fontRef:find('ttf') then
            fontRef = fontRef:gsub('%.ttf', '')
            fonts:add(fontRef)
        end
    end

    fontIndex = 1

    size = 12
    alphabet = ''
    for i=32,127 do
        if i%size == 0 and #alphabet > 0 then
            alphabet = alphabet..NL
        end
        alphabet = alphabet..string.char(i)
    end    

    parameter:watch('fontIndex')
end

function autotest()
    fontIndex = randomInt(#fonts)
end

function draw()
    background(colors.white)

    local x = 0

    fontSize(28)

    textPosition(0)
    for index,name in ipairs(fonts) do        
        fontName(name)
        text(name, x, textPosition())

        if index == fontIndex then
            textColor(colors.red)
        else
            textColor(colors.black)
        end

        if textPosition() > H then
            x = x + Anchor(4):size(1,1).x
            textPosition(0)
        end
    end
    
    textColor(colors.black)
    fontName(fonts[fontIndex])
    
    textPosition(0)
    for size=5,80,5 do
        fontSize(size)
        text(fontName(), W/3, textPosition())
    end

    fontSize(24)
    text(alphabet, W*2/3)
end

function keypressed(key)
    if key == 'down' then
        fontIndex = fontIndex % #fonts + 1

    elseif key == 'up' then
        fontIndex = (fontIndex - 1) % #fonts
        if fontIndex == 0 then
            fontIndex = #fonts
        end
    end
end
