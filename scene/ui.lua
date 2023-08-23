UI = class() : extends(Rect, MouseEvent, KeyboardEvent)

UI.innerMarge = 5

function UI:init(label)
    Rect.init(self)
    MouseEvent.init(self)

    self.label = label

    self.styles = Array{
        fillColor = colors.gray,
        textColor = colors.white,
        fontSize = 22,
    }
end

function UI:getLabel()
    if self.value then
        return tostring(self.label)..' = '..(tostring(self.value) or '')
    end
    return tostring(self.label)
end

function UI:fontSize()
    if self.parent then
        fontSize(self.parent.state == 'open' and 28 or 22)
    else
        fontSize(self.styles.fontSize)
    end
end

function UI:computeSize()    
    self:fontSize()

    local w, h = textSize(self:getLabel())
    self.size:set(w + 2 * UI.innerMarge, h)
end

function UI:draw()
    if not self.label then return end
    
    self:drawBack()
    self:drawFront()
end

function UI:drawBack()
    noStroke()
    fill(self.styles.fillColor)
    rect(self.position.x, self.position.y, self.size.x, self.size.y, 4)
end

function UI:drawFront()
    if self.active then
        textColor(colors.red)
    else
        textColor(self.styles.textColor)
    end

    self:fontSize()

    local wrapSize = self.styles.wrapSize
    local wrapAlign = self.styles.wrapAlign

    if self.styles.mode == CENTER then
        textMode(CENTER)
        text(self:getLabel(), self.position.x + self.size.x/2, self.position.y + self.size.y/2, wrapSize, wrapAlign)
    else
        textMode(CORNER)
        text(self:getLabel(), self.position.x + UI.innerMarge, self.position.y, wrapSize, wrapAlign)
    end
end
