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
    self:action('next', function () processManager:next() end)
    self:action('previous', function () processManager:previous() end)
    self:action('random', function () processManager:random() end)
    self:action('loop', function () processManager:loop() end)

    self:group('info')
    self:watch('fps', 'getFPS()')
    self:watch('position', 'X..","..Y')
    self:watch('size', 'W..","..H')
    self:watch('delta time', 'string.format("%.3f", DeltaTime)')
    self:watch('elapsed time', 'string.format("%.1f", ElapsedTime)')
    self:watch('version', 'version')
    
    self:watch('startPosition', 'mouse.startPosition')
    self:watch('position', 'mouse.position')
    self:watch('previousPosition', 'mouse.previousPosition')
    self:watch('move', 'mouse.move')
end

function Parameter:init()
    Scene.init(self)
    self.currentGroup =  self
end

function Parameter:openGroup(group)
    self:setStateForAllGroups('hidden', false)
    group.state = 'open'
    group.visible = true
end

function Parameter:closeGroup(group)
    self:setStateForAllGroups('close', true)
    group.state = 'close'
    group.visible = true
end

function Parameter:setStateForAllGroups(state, visible)
    state = state or 'hidden'
    visible = visible or false
    self:foreach(
        function (node)
            if node.state then
                node.state = state
                node.visible = visible
            end
        end)
end

function Parameter:group(label, open)
    local newGroup = Node()

    if open then 
        self:openGroup(newGroup)
    else
        newGroup.state = 'close'
        newGroup.visible = true
    end

    local newButton = UIButton(label, function ()
        if newGroup.state == 'close' then
            self:openGroup(newGroup)
        else
            self:closeGroup(newGroup)
        end
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

function Parameter:boolean(label, varName)
    self.currentGroup:add(UICheck(label, varName))
end

function Parameter:integer(label, varName, min, max, initValue)
    self.currentGroup:add(UISlider(label, varName, min, max))
end

function Parameter:draw()    
    self:layout()
    Scene.draw(self)
    resetMatrix()
end
