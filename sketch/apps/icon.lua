function setup()
    size = 16
    ratio = 32

    iconSize = vec2(size * ratio, size * ratio)
    iconPosition = vec2(
        (W - iconSize.x) / 2,
        (H - iconSize.x) / 2)

    frontColor = colors.blue
    backColor = colors.green
    
    fb = Image('data/icon.png', size, size, 'normal', colors.gray)
    fb:getImageData()

    palette = Array{
        colors.red,
        colors.green,
        colors.blue,
        colors.gray,
        colors.white,
        colors.black,
    }
end

function mousemoved(mouse)
    mousereleased(mouse)
end

function mousereleased(mouse)
    local w = size * 2
    for i, clr in ipairs(palette) do
        if Rect(iconPosition.x+(i-1)*w, iconPosition.y - w, w, w):contains(mouse.position) then
            if mouse.id == 1 then
                frontColor = clr
            else
                backColor = clr
            end
            return
        end
    end

    if Rect(iconPosition.x, iconPosition.y, iconSize.x, iconSize.y):contains(mouse.position) then
        local x = mouse.position.x - iconPosition.x
        local y = mouse.position.y - iconPosition.y
        
        x, y = floor(x/ratio), floor(y/ratio)

        local clr = mouse.id == 1 and frontColor or backColor
        if (0 <= x and x < size and 
            0 <= y and y < size)
        then
            fb:set(x, y, clr)
            fb.imageData:encode('png', 'data/icon.png')
        end
    end
end

function draw()
    fb:update()
    fb.texture:setFilter('nearest', 'nearest')

    spriteMode(CENTER)

    sprite(fb, size*1, size*3)
    sprite(fb, size*3, size*3, size*2, size*2)
    sprite(fb, size*7, size*3, size*4, size*4)
    
    sprite(fb, W/2, H/2, size*ratio, size*ratio)
    
    local w = size * 2
    translate(iconPosition.x, iconPosition.y - w)
    
    for i, clr in ipairs(palette) do
        fill(clr)
        rect((i-1)*w, 0, w, w)
    end
end
