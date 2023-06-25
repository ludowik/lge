Parameter = class() : extends(Scene)

function Parameter:init()
    Scene.init(self)
end

function Parameter:layout()
    local x, y = 0, Y
    for _,item in ipairs(self.items) do
        item:computeSize()
        x = W - item.size.x
        
        item.position:set(x, y)
        y = y + item.size.y
    end
end

function Parameter:action(label, callback)
    self:add(UIButton(label, callback))
end

function Parameter:watch(label, expression)
    self:add(UIExpression(label, expression))
end

function Parameter:draw()
    self:layout()
    Scene.draw(self)    
end

