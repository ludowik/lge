Bind = class()

function Bind:init(object, ref)
    self.object = ref and object
    self.ref = ref or object
end

function Bind:__tostring()
    return tostring(self:get())
end

function Bind:get()
    local object = self.object or _G.env or _G
    local result = object[self.ref]
    if result then return result end
    return evaluateExpression(self.ref) or nil
end

function Bind:set(value)
    local object = self.object or _G.env or _G
    object[self.ref] = value
end

function Bind:increment(value)
    self:set(self:get() + value)
end

function Bind:decrement(value)
    self:set(self:get() - value)
end

function Bind:toggle()
    self:set(not self:get())
end
