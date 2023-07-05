UIExpression = class() : extends(UI)

function UIExpression:init(label, expression)
    self.expression = expression or label
    UI.init(self, label)
end

function UIExpression:getLabel()
    return self.label..': '..self:evaluateExpression()
end

function UIExpression:evaluateExpression()
    return tostring(loadstring('return ' .. self.expression)() or '')
end
