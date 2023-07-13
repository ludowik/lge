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


Bind = class()

function Bind:init(object, ref)
    self.object = object
    self.ref = ref
end

function Bind:get()
    if self.object then
        __object__ = self.object
        local result = tostring(loadstring('return __object__.'..self.ref)() or '')
        __object__ = nil
        return result
    end

    return tostring(loadstring('return ' .. self.ref)() or '')
end

function Bind:set()
end
