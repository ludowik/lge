function draw()
    background()

    fontSize(64)

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
end
