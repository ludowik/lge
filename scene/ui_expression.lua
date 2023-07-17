UIExpression = class() : extends(UI)

function UIExpression:init(label, expression)
    self.expression = expression or label

    local type_label = type(label)
    if type_label == 'table' then
        label = self.expression.name or self.expression.ref
    end

    UI.init(self, label)
end

function UIExpression:getLabel()
    return tostring(self.label)..': '..self:evaluateExpression()
end

function UIExpression:evaluateExpression()
    local type_expression = type(self.expression)
    if type_expression == 'string' then
        return tostring(loadstring('return ' .. self.expression)() or '')

    elseif type_expression == 'table' then
        return self.expression:get()
    end
    return 'Expression error !'
end
