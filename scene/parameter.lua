Parameter = class() : extends(Scene)

function Parameter.setup()
    Parameter.innerMarge = 5
end

function Parameter:init()
    Scene.init(self)
    self.currentGroup =  self
end

function Parameter:group(label, open)
    local newGroup = Node()
    newGroup.state = open and 'open' or 'close'

    local newButton = UIButton(label, function ()
        self:foreach(function (node)
            if node.state then
                node.state = 'close'
            end
        end)
        newGroup.state = newGroup.state == 'close' and 'open' or 'close'
    end)
    newButton:attrib{
        parent = newGroup,
        styles = {
            fillColor = colors.blue,
            textColor = colors.white,
        }
    }
    newGroup:add(newButton)

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
    love.graphics.translate(X, Y)
    Scene.draw(self)
    love.graphics.reset()
end
