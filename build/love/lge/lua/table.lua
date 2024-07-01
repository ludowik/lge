local __cloningObjects = {}
function table.clone(self)
    if self.clone and self.clone ~= table.clone then return self:clone() end
    
    if __cloningObjects[self] then return __cloningObjects[self] end

    local t = Array()
    __cloningObjects[self] = t

    for k, v in pairs(self) do
        if type(v) == 'table' then
            t[k] = Array.clone(v)
        else
            t[k] = v
        end
    end

    for i, v in ipairs(self) do
        if type(v) == 'table' then
            t[i] = Array.clone(v)
        else
            t[i] = v
        end
    end

    setmetatable(t, getmetatable(self))

    __cloningObjects[self] = nil
    return t
end
