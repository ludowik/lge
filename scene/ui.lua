UI = class() : extends(Rect)

UI.innerMarge = 5

function UI:init(label)
    Rect.init(self)
    self.label = label

    self.styles = {
        textColor = colors.white
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

UIButton = class() : extends(UI)

function UIButton:init(label, callback)
    UI.init(self, label)
    self.callback = callback

    self:attrib{
        styles = {
            fillColor = Color(0, 0.2, 1, 0.1)
        }
    }
end

function UIButton:draw()
    fill(self.styles.fillColor)
    rect(self.position.x, self.position.y, self.size.x, self.size.y)
    UI.draw(self)
end

UIExpression = class() : extends(UI)

function UIExpression:init(label, expression)
    self.expression = expression or label
    UI.init(self, label)
end

function UIExpression:evaluateExpression()
    return loadstring('return ' .. self.expression)()
end

function UIExpression:computeSize()
    love.graphics.setFont(font)
    local w1, h1 = textSize(self:getLabel())
    local w2, h2 = textSize(self:evaluateExpression())
    self.size:set(w1 + UI.innerMarge + w2, max(h1, h2))
end

function UIExpression:draw()
    love.graphics.setFont(font)
    local w, h = textSize(self:getLabel())

    textColor(colors.white)
    
    text(self:getLabel(), self.position.x, self.position.y)
    text(self:evaluateExpression(), self.position.x + w + UI.innerMarge, self.position.y)
end
