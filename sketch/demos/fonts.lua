function setup()
    if getOS() == 'web' then
        fonts = {
            'Arial',
            'Courier New',
            'Verdana',
        }
    else        
        fonts = dir('resources/fonts', 'ttf')
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

    parameter:integer('fontIndex', 1, #fonts)
end

function autotest()
    fontIndex = randomInt(#fonts)
end

function draw()
    background(colors.white)

    local x = LEFT

    local top = TOP
    textPosition(top)

    fontSize(28)
    
    for index,name in ipairs(fonts) do
        name = name:gsub('%.ttf', '')

        if index == fontIndex then
            textColor(colors.red)
        else
            textColor(colors.black)
        end

        fontName(name)
        text(name, x, textPosition())
        
        if textPosition() > H then
            x = x + Anchor(4):size(1,1).x
            textPosition(0)
        end
    end
    
    textPosition(top)

    textColor(colors.black)    
    fontName(fonts[fontIndex]:gsub('%.ttf', ''))
    
    for size=12,50,3 do
        fontSize(size)
        text(fontName(), W/3, textPosition())
    end

    fontSize(24)
    text(alphabet, W*2/3, top)
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
