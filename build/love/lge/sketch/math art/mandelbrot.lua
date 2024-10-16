function setup()
    y = 1
    drawAll = false
end

function draw()
    background()

    prepare()

    translate(CX, CY)
    
    spriteMode(CENTER)
    sprite(img)
end

function prepare()
    if drawOK then
        return
    end

    local x1 = -2.2
    local x2 =  1.6
    
    local y1 = -1.5
    local y2 =  1.5

    local SIZE = 1024
    
    local zoom = floor(SIZE / (y2 - y1))
    
    local iteration_max = 50

    local image_x = floor((x2 - x1) * zoom)
    local image_y = floor((y2 - y1) * zoom)

    img = img or FrameBuffer(even(image_x+1), even(image_y+1))
    
    local y_start, y_end
    if drawAll then
        y_start, y_end = 1, image_y
        drawOK = true
    else
        y_start, y_end = y, y
    end

    for x = 1,image_x do
        for y = y_start, y_end do
            local c_r = x / zoom + x1
            local c_i = y / zoom + y1
            
            local z_r = 0
            local z_i = 0
            
            local i = 0

            while z_r*z_r + z_i*z_i < 4 and i < iteration_max do
                local tmp = z_r
                
                z_r = z_r^2 - z_i^2 + c_r
                z_i = 2 * z_i * tmp + c_i
                
                i = i + 1
            end

            if (x-1 >= 0 and x-1 < img.width and
                y-1 >= 0 and y-1 < img.height)
            then
                if i == iteration_max then
                    img:setPixel(x-1, y-1, colors.black)
                else
                    img:setPixel(x-1, y-1, Color.hsl(i/iteration_max))
                end
            end
        end
    end
    
    if not drawAll then
        if y == image_y then drawOK = true end
        y = y % image_y + 1
    end
end
