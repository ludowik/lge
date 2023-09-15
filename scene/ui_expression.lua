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
    local expression = self.expression
    
    local type_expression = type(expression)
    if type_expression == 'string' then
        return tostring(loadstring('return ' .. expression)())

    elseif type_expression == 'table' then
        return tostring(expression)
    end

    return 'Expression error !'
end
