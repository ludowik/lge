Parameter = class() : extends(Scene)

function Parameter.setup()
    Parameter.innerMarge = 5
end

function Parameter:initMenu()
    self:group('menu')
    self:action('quit', quit)
    self:action('update', function () self.scene = UpgradeApp() end)
    self:action('reload', reload)
    self:action('restart', restart)

    self:group('navigate')
    self:action('next', function () process:next() end)
    self:action('previous', function () process:previous() end)
    self:action('random', function () process:random() end)
    self:action('loop', function () process:loop() end)

    self:group('info')
    self:watch('fps', 'getFPS()')
    self:watch('position', 'X..","..Y')
    self:watch('size', 'W..","..H')
    self:watch('delta time', 'string.format("%.3f", DeltaTime)')
    self:watch('elapsed time', 'string.format("%.1f", ElapsedTime)')

    self:group('mouse')
    self:watch('startPosition', 'mouse.startPosition')
    self:watch('position', 'mouse.position')
    self:watch('previousPosition', 'mouse.previousPosition')
    self:watch('move', 'mouse.move')
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
    translate(X, Y)
    Scene.draw(self)
    resetMatrix()
end
