UI = class() : extends(Rect, MouseEvent, KeyboardEvent)

function UI.setup()
    UI.innerMarge = 8
    UI.outerMarge = 4

    UI.styles = {
        fontSize = 32,
        fontName = DEFAULT_FONT_NAME,
    }
end

function UI:init(label)
    Rect.init(self)
    MouseEvent.init(self)

    self.label = label

    self.styles = Array{
        fillColor = Color(0.5),
        textColor = colors.white,

        fontSize = UI.styles.fontSize,
        fontName = UI.styles.fontName,
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
        return string.format('%.0f', value)
    else
        if abs(value) <= 0.01 then
            return string.format('%f', value)
        else
            return string.format('%.2f', value)
        end
    end
end

function UI:fontStyle()
    fontSize(self.styles.fontSize)
    fontName(self.styles.fontName)
end

function UI:computeSize()
    if self.fixedSize then
        self.size:set(self.fixedSize.x, self.fixedSize.y)
        return
    end

    self:fontStyle()

    local label = self:getLabel()
    if label:startWith('@') then
        fontName('foundation-icons')
        label = utf8.char(iconsFont[label:mid(2)])
    end

    local w, h = textSize(label)
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
        fill(self.styles.fillColor)
    else
        noFill()
    end


    if eventManager.currentObject == self then
        fill(colors.red)
    end
    
    local r = self.styles.radiusBorder or 4

    rectMode(CORNER)
    rect(self.position.x, self.position.y, self.size.x, self.size.y, r)
end

function UI:drawFront()
    if self.active then
        textColor(colors.red)
    else
        textColor(self.styles.textColor)
    end

    self:fontStyle()

    local wrapSize = self.styles.wrapSize
    local wrapAlign = self.styles.wrapAlign

    local label = self:getLabel()
    if label:startWith('@') then
        fontName('foundation-icons')
        label = utf8.char(iconsFont[label:mid(2)])
    end

    if self.styles.mode == CENTER then
        textMode(CENTER)
        text(label,
            self.position.x + self.size.x / 2,
            self.position.y + self.size.y / 2,
            wrapSize, wrapAlign)

    else
        textMode(CORNER)
        text(label,
            self.position.x + UI.innerMarge,
            self.position.y,
            wrapSize, wrapAlign)
    end
end
