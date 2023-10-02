Parameter = class():extends(Scene)

function Parameter.setup()
    Parameter.innerMarge = 5
end

function Parameter:init(layoutMode)
    Scene.init(self)
    self.currentGroup = self
    self.visible = true
    self.layoutMode = layoutMode or 'right'
end

function Parameter:initControlBar()
    self:action('sketches',
        function ()
            openSketches()
            engine.parameter.visible = false
        end,
        {
            styles = {
                fillColor = colors.transparent,
                strokeColor = colors.transparent,
                textColor = colors.transparent,
            },
            fixedPosition = vec2(Anchor(3, 6):pos(0, 0).x, -Y),
            fixedSize = Anchor(3, 8):size(1.25, 1)
        })

    self:action('menu',
        function ()
            engine.parameter.visible = not engine.parameter.visible
        end,
        {
            styles = {
                fillColor = colors.transparent,
                strokeColor = colors.transparent,
                textColor = colors.transparent,
            },
            fixedPosition = vec2(Anchor(3, 6):pos(1.75, 0).x, -Y),
            fixedSize = Anchor(3, 8):size(1.25, 1)
        })
end

function Parameter:addMainMenu()
    self.menu = self:group('main')

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
end

function Parameter:addNavigationMenu()
    self:group('navigation')
    
    self:action('fused', function () toggleFused() end)
    self:action('next', function () processManager:next() end)
    self:action('previous', function () processManager:previous() end)
    self:action('random', function () processManager:random() end)
    self:action('loop', function () processManager:loop() end)
end

function Parameter:addCaptureMenu()
    self:group('capture')

    self:action('pause', noLoop)
    self:action('frame', redraw)
    self:action('resume', loop)
    self:action('capture', function ()
        engine.parameter.visible = false
        love.graphics.captureScreenshot(function (imageData)
            imageData:encode('png', env.__name..'.png')
            engine.parameter.visible = true
        end)
    end)
end

function Parameter:openGroup(group)
    self:setStateForAllGroups('close', false)
    group.state = 'open'
    group.visible = true
end

function Parameter:closeGroup(group)
    self:setStateForAllGroups('close', true)
    group.state = 'close'
    group.visible = true
end

function Parameter:setStateForAllGroups(state, visible)
    state = state
    visible = visible or false
    self:foreach(
        function(node)
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
        self:closeGroup(newGroup)
    end

    if label then
        local newButton = UIButton(label, function ()
            if newGroup.state == 'close' then
                self:openGroup(newGroup)
            else
                self:closeGroup(newGroup)
            end
        end)

        newButton:attrib {
            parent = newGroup,
            styles = {
                fillColor = colors.blue,
                textColor = colors.white,
                fontSize = 28
            },
            mousereleased = function (...)
                MouseEvent.mousereleased(...)
            end,
        }

        newGroup:add(newButton)
    end

    self.currentGroup = newGroup
    self:add(self.currentGroup)

    return newGroup
end

function Parameter:declareParameter(varName, initValue)
    if type(varName) == 'string' and env[varName] == null then
        env[varName] = initValue
    end
end
function Parameter:space()
    self.currentGroup:add(UI())
end

function openURL(url)    
    love.system.openURL(url)
end

function Parameter:link(label, url)
    self.currentGroup:add(UIButton(label, function ()
        openURL(url or label)
    end))
end

function Parameter:linksearch(label)
    self.currentGroup:add(UIButton(label, function ()
        openURL('https://www.google.com/search?q='..label)
    end))
end

function Parameter:action(label, callback, attribs)
    local ui = UIButton(label, callback)
    if attribs then
        ui:attrib(attribs)
    end
    self.currentGroup:add(ui)
end

function Parameter:watch(label, expression)
    self.currentGroup:add(UIExpression(label, expression))
end

function Parameter:boolean(label, varName, initValue, callback)
    self:declareParameter(varName, initValue)
    self.currentGroup:add(UICheck(label, varName, callback))
end

function Parameter:integer(label, varName, min, max, initValue, callback)
    self:declareParameter(varName, initValue or min)
    local ui = UISlider(label, varName, min, max, callback)
    ui.intValue = true
    ui.incrementValue = 1
    self.currentGroup:add(ui)
    return ui
end

function Parameter:number(label, varName, min, max, initValue, callback)
    self:declareParameter(varName, initValue or min)
    local ui = UISlider(label, varName, min, max, callback)
    ui.intValue = false
    ui.incrementValue = 0.2
    self.currentGroup:add(ui)
    return ui
end

function Parameter:draw(x, y)
    self:layout(x, y)
    Scene.draw(self)
end
