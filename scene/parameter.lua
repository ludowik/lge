Parameter = class() : extends(Scene)

function Parameter.setup()
    Parameter.innerMarge = 5
end

function Parameter:initMenu()
    self:group('menu')
    self:action('update', function () self.scene = UpdateApp() end)

    self:action('update from git', function ()
        updateScripts(true)
        quit()
    end)
    self:action('update from local', function ()
        updateScripts(false)
        quit()
    end)

    self:action('reload', reload)
    self:action('restart', restart)
    self:action('exit', exit)

    --self:group('navigate')
    self:space()
    self:action('fused', function () toggleFused() end)
    self:action('next', function () processManager:next() end)
    self:action('previous', function () processManager:previous() end)
    self:action('random', function () processManager:random() end)
    self:action('loop', function () processManager:loop() end)

    self:group('sketch', true)
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
            if newGroup == self.items[1] then
                self:openGroup(self.items[2])
            else
                self:openGroup(self.items[1])
            end
            --self:closeGroup(newGroup)
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

function Parameter:space()
    self.currentGroup:add(UI())
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
    local ui = UISlider(label, varName, min, max)
    ui.intValue = true
    ui.incrementValue = 1
    self.currentGroup:add(ui)
    return ui
end

function Parameter:number(label, varName, min, max, initValue)
    local ui = UISlider(label, varName, min, max)
    ui.intValue = false
    ui.incrementValue = 0.2
    self.currentGroup:add(ui)
    return ui
end

function Parameter:draw()    
    self:layout(0, 0, 'right')
    Scene.draw(self)
end
