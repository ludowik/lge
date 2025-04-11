function setup()
    fb = FrameBuffer(128, 128)
    fb.canvas:setFilter('nearest', 'nearest')
end

function draw()
    background(colors.white)
    
    fb:render(function ()
        fill(colors.red)
        rect(0, 0, 128, 128)
    end)

    scale = 4

    sprite(fb, DX, DY, scale*128, scale*128)
end
