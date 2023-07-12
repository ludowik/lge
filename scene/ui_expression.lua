UIExpression = class() : extends(UI)

function UIExpression:init(label, expression)
    self.expression = expression or label

    local type_expression = type(label)
    if type_expression == 'table' then
        label = self.expression.name or self.expression.expression
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
        if self.expression.name then
            return tostring(self.expression.object[self.expression.name])
        
        elseif self.expression.expression then
            __object__ = self.expression.object
            local result = tostring(loadstring('return __object__.'..self.expression.expression)() or '')
            __object__ = nil
            return result
        end
    end
    return 'error'
end
