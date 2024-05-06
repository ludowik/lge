function setup()
    zoom = 1
    translation = vec2()

    parameter:integer('font size', 'size', 2, 100, 22)
end

function mousemoved(touch)
    translation = translation + vec2(touch.deltaPos.x, touch.deltaPos.y)
end

function draw()
    background()

    fontName('foundation-icons')
    fontSize(size)

    textMode(CORNER)

    local wMax, hMax, n = 0, 0, 314
    for i=0,n do
        local w, h = textSize(''..utf8.char(0xF100+i))
        wMax = max(w, wMax)
        hMax = max(h, hMax)
    end

    hMax = hMax + 4

    local i = 0

    local ncol = floor((W -2*wMax) / wMax)
    local nrow = floor((n) / ncol)

    translate(CX, CY)
    
    scale(zoom)

    translate(
        translation.x - ncol*wMax/2,
        translation.y - nrow*hMax/2)

    textColor(colors.white)

    local row, col = 0, 0
    for k,v in pairs(iconsFont) do
        if col >= ncol then
            row = row + 1
            col = 0
        end

        text(''..utf8.char(v), col*wMax, row*hMax)

        col = col + 1
    end

    fontName('arial')
    fontSize(hMax/4)

    textMode(CENTER)
    
    local pos = (vec2(mouse) + translation) * zoom

    local globalX, globalY = love.graphics.inverseTransformPoint(mouse.position.x, mouse.position.y)

    row, col = 0, 0
    for k,v in pairs(iconsFont) do
        if col >= ncol then
            row = row + 1
            col = 0
        end

        if (globalX > col*wMax and 
            globalX < col*wMax+wMax and 
            globalY < row*hMax and 
            globalY > row*hMax - hMax)
        then
            textColor(colors.red)
        else
            textColor(colors.lightgray)
        end

        text(k, col*wMax+wMax/2, row*hMax+hMax)

        col = col + 1
    end

    --    for row=0,row-1 do
    --        for col=0,col-1 do
    --            text(''..utf8.char(0xF100+i), col*wMax, HEIGHT-row*hMax)
    --            i = i + 1
    --        end
    --    end
end
