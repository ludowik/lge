function setup()
    pixelRatio = 2
    logo = FrameBuffer(1024/pixelRatio, 1024/pixelRatio)
end
    
function draw()
    background()

    logo:setContext()
    scale(1/pixelRatio, 1/pixelRatio)

    fontSize(W)

    blendMode(NORMAL)

    textMode(CENTER)
	
    function drawtext(str, colors, x, y)        
        for i=1,#str do
            textColor(colors[i%#colors+1])
            text(str:sub(i, i), x or 100, y or 100)
        end
    end

    local colors = {colors.red:alpha(.5), colors.green, colors.blue}

    drawtext('LCA', colors)
    drawtext('LGE', colors, 100, 200)
    drawtext('CGE', colors, 100, 300)
    drawtext('Creative Coding', colors, 100, 400)

    drawtext('LCA', colors)
    drawtext('LGE', colors, 100, 200)
    drawtext('CGE', colors, 100, 300)
    drawtext('Creative Coding', colors, 100, 400)

    resetContext()

    sprite(logo, 0, 0, 64, 64)
end
