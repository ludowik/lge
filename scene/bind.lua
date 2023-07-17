Bind = class()

function Bind:init(object, ref)
    self.object = object
    self.ref = ref
end

function Bind:__tostring()
    return self:get()
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
    assert(false)
end
