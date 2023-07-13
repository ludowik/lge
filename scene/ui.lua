UI = class() : extends(Rect, MouseEvent)

UI.innerMarge = 5

function UI:init(label)
    Rect.init(self)
    MouseEvent.init(self)

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
        fontSize(self.parent.state == 'open' and 32 or 16)
    else
        fontSize(20)
    end
end

function UI:computeSize()
    self:fontSize()

    local w, h = textSize(self:getLabel())
    self.size:set(w + 2 * UI.innerMarge, h)
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
    text(self:getLabel(), self.position.x + UI.innerMarge, self.position.y)
end
