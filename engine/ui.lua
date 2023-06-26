UI = class() : extends(Rect)

UI.innerMarge = 5

function UI:init(label)
    Rect.init(self)
    self.label = label
end

function UI:computeSize()
    love.graphics.setFont(font)
    self.size:set(textSize(self.label))
end

function UI:draw()
    love.graphics.setFont(font)
    if self.active then
        fill(colors.red)
    else
        fill(colors.black)
    end
    text(self.label, self.position.x, self.position.y)
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
    local w1, h1 = textSize(self.label)
    local w2, h2 = textSize(self:evaluateExpression())
    self.size:set(w1 + UI.innerMarge + w2, math.max(h1, h2))
end

function UIExpression:draw()
    love.graphics.setFont(font)
    local w, h = textSize(self.label)
    text(self.label, self.position.x, self.position.y)
    text(self:evaluateExpression(), self.position.x + w + UI.innerMarge, self.position.y)
end
