Parameter = class() : extends(Scene)

function Parameter.setup()
    Parameter.innerMarge = 5

    parameter = Parameter()
    parameter:group('menu')
    parameter:action('quit', quit)
    parameter:action('update', function () parameter.scene = UpgradeApp() end)
    parameter:action('reload', reload)
    parameter:action('restart', restart)

    parameter:group('navigate')
    parameter:action('next', function () process:next() end)
    parameter:action('previous', function () process:previous() end)
    parameter:action('random', function () process:random() end)
    parameter:action('loop', function () process:loop() end)

    parameter:group('info')
    parameter:watch('fps', 'getFPS()')
    parameter:watch('position', 'X..","..Y')
    parameter:watch('size', 'W..","..H')
    parameter:watch('delta time', 'string.format("%.3f", DeltaTime)')
    parameter:watch('elapsed time', 'string.format("%.1f", ElapsedTime)')

    parameter:group('mouse', true)
    parameter:watch('startPosition', 'mouse.startPosition')
    parameter:watch('position', 'mouse.position')
    parameter:watch('previousPosition', 'mouse.previousPosition')
    parameter:watch('move', 'mouse.move')
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
