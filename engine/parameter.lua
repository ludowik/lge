Parameter = class() : extends(Scene)

function Parameter:init()
    Scene.init(self)
    self.currentGroup =  self
end

function Parameter:group(label, open)
    local newGroup = Scene()
    newGroup.state = open and 'open' or 'close'
    newGroup:add(UIButton(label, function ()
        newGroup.state = newGroup.state == 'close' and 'open' or 'close'
    end))

    self.currentGroup = newGroup
    self:add(self.currentGroup)
end

function Parameter:action(label, callback)
    self.currentGroup:add(UIButton(label, callback))
end

function Parameter:watch(label, expression)
    self.currentGroup:add(UIExpression(label, expression))
end

function Parameter:draw()
    self:layout()
    Scene.draw(self)
end

