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

function UI:fontSize()
    if self.parent then
        fontSize(self.parent.state == 'open' and 32 or 18)
    else
        fontSize(22)
    end
end

function UI:computeSize()
    self:fontSize()
    self.size:set(textSize(self:getLabel()))
end

function UI:draw()
    noStroke()
    fill(self.styles.fillColor)
    rect(self.position.x, self.position.y, self.size.x, self.size.y)
    
    if self.active then
        textColor(colors.red)
    else
        textColor(self.styles.textColor)
    end

    self:fontSize()

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
