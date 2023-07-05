UI = class() : extends(Rect)

UI.innerMarge = 5

function UI:init(label)
    Rect.init(self)
    self.label = label

    self.styles = {
        fillColor = colors.gray,
        textColor = colors.white,
    }
end

function UI:getLabel()
    return self.label
end

function UI:computeSize()
    love.graphics.setFont(font)
    self.size:set(textSize(self:getLabel()))
end

function UI:draw()
    noStroke()
    fill(self.styles.fillColor)
    rect(self.position.x, self.position.y, self.size.x, self.size.y)
    
    love.graphics.setFont(font)
    if self.active then
        textColor(colors.red)
    else
        textColor(self.styles.textColor)
    end

    textMode(CORNER)
    text(self:getLabel(), self.position.x, self.position.y)
end

function UI:mousepressed(mouse)
    self:click()
end

function UI:mousemoved(mouse)
end

function UI:mousereleased(mouse)
end

function UI:click()
    if self.callback then
        self:callback()
        return true
    end    
end
