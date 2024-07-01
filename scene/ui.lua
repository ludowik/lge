UI = class():extends(Rect, MouseEvent, KeyboardEvent)

UI.innerMarge = 6
UI.styles = {
    fontSize = 18
}

function UI:init(label)
    Rect.init(self)
    MouseEvent.init(self)

    self.label = label

    self.styles = Array {
        fillColor = Color(0.5, 0.5),
        textColor = colors.white,
        fontSize = UI.styles.fontSize,
    }

    self.visible = true
end

function UI:getLabel()
    local label = tostring(self.label):replace('_', ' '):proper()
    if self.value then
        return label .. ' = ' .. self:getValue()
    end
    return label
end

function UI:getValue(value)
    value = value or self.value
    if type(value) == 'table' and value.get then
        value = value:get()
    end

    local strValue
    if type(value) == 'number' then
        strValue = self:formatValue(value)
    else
        strValue = tostring(value)
    end
    return strValue
end

function UI:formatValue(value)
    if self.intValue then
        return string.format('%d', value)
    else
        if value <= 0.01 then
            return string.format('%f', value)
        else
            return string.format('%.2f', value)
        end
    end
end

function UI:fontSize()
    fontSize(self.styles.fontSize)
end

function UI:computeSize()
    if self.fixedSize then
        self.size:set(self.fixedSize.x, self.fixedSize.y)
        return
    end

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
    if self.styles.strokeColor then
        strokeSize(self.styles.strokeSize)
        stroke(self.styles.strokeColor)
    else
        noStroke()
    end

    if self.styles.fillColor then
        if eventManager.currentObject == self then
            fill(colors.red:alpha(0.25))
        else
            fill(self.styles.fillColor)
        end
    else
        noFill()
    end

    local r = self.styles.radiusBorder or 4
    rect(self.position.x, self.position.y, self.size.x, self.size.y, r)
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
        text(self:getLabel(), self.position.x + self.size.x / 2, self.position.y + self.size.y / 2, wrapSize, wrapAlign)
    else
        textMode(CORNER)
        text(self:getLabel(), self.position.x + UI.innerMarge, self.position.y, wrapSize, wrapAlign)
    end
end
