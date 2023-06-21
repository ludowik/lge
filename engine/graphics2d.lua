Graphics2d = class()

function Graphics2d.background(clr)
    clr = clr or colors.black
    
    love.graphics.clear(clr.r, clr.g, clr.b, clr.a)
end

function Graphics2d.fill(clr)
    Graphics2d.fillColor = clr or colors.red
end

function Graphics2d.text(str, x, y)
    x = x or 0
    y = y or 0

    if Graphics2d.fillColor then
        love.graphics.setColor(Graphics2d.fillColor.r, Graphics2d.fillColor.g, Graphics2d.fillColor.b, Graphics2d.fillColor.a)
    end
    love.graphics.print(str, x, y)
end
