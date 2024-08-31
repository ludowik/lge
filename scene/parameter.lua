Parameter = class():extends(Scene)

function Parameter.setup()
end

function Parameter:init(layoutMode)
    Scene.init(self)
    self.currentGroup = self
    self.currentMenu = self
    self.visible = true
    self.layoutMode = layoutMode or 'right'
end

function Parameter:randomizeParameter()
    for _,ui in ipairs(self.items) do
        if ui.items then
            Parameter.randomizeParameter(ui)

        elseif ui.set then
            ui:set(random(ui.minValue, ui.maxValue))
        end
    end
end

function Parameter:initControlBar()
    local styles = {
        fillColor = colors.transparent,
        strokeColor = colors.transparent,
        textColor = colors.transparent,
    }

    if fused() then
        self:action('menu',
            function ()
                if mouse.elapsedTime > 5 then
                    toggleFused()
                end
            end,
            {
                styles = styles,
                fixedPosition = vec2(W-MIN_SIZE/3, 0),
                fixedSize = vec2(MIN_SIZE/3, max(LEFT, TOP)),
            })
        return
    end
    
    self:action('sketches',
        function ()
            openSketches()
            engine.parameter.visible = false
        end,
        {
            styles = styles,
            fixedPosition = vec2(),
            fixedSize = vec2(MIN_SIZE/3, max(LEFT, TOP)),
        })

    self:action('menu',
        function ()
            engine.parameter.visible = not engine.parameter.visible
        end,
        {
            styles = styles,
            fixedPosition = vec2(W-MIN_SIZE/3, 0),
            fixedSize = vec2(MIN_SIZE/3, max(LEFT, TOP)),
        })

    self:action('previous sketch',
        function ()
            if engine.parameter.currentMenu and engine.parameter.currentMenu.label == 'navigation' then
                processManager:previous()
            end
        end,
        {
            styles = styles,
            fixedPosition = vec2(0, H-max(LEFT, TOP)),
            fixedSize = vec2(MIN_SIZE/3, max(LEFT, TOP)),
        })

    self:action('next sketch',
        function ()
            if engine.parameter.currentMenu and engine.parameter.currentMenu.label == 'navigation' then
                processManager:next()
            end
        end,
        {
            styles = styles,
            fixedPosition = vec2(W-MIN_SIZE/3, H-max(LEFT, TOP)),
            fixedSize = vec2(MIN_SIZE/3, max(LEFT, TOP)),
        })
end

function Parameter:addMainMenu()
    self:action('update from local', function ()
        updateScripts(false)
    end)
    
    self.menu = self:group('main')

    self:space()
    self:action('fused', function () toggleFused() end)

    self:space()
    self:action('update from git', function ()
        updateScripts(true)
    end)
    self:action('update from local', function ()
        updateScripts(false)
    end)

    self:space()
    self:action('reload', reload)
    self:action('restart', restart)

    self:space()
    self:action('info', function() processManager:setSketch('info') end)

    self:space()
    self:action('instrument', function ()
        instrument:instrumentFunctions()
        instrument.active = not instrument.active
    end)

    self:space()
    self:action('exit', exit)
end

function Parameter:addNavigationMenu()
    self:group('navigation')
    
    self:space()
    self:action('next', function () processManager:next() end)
    self:action('previous', function () processManager:previous() end)

    self:space()
    self:action('random', function () processManager:random() end)

    self:space()
    self:action('loop', function() processManager:loopProcesses() end)

    self:space()
    self:link('web version', 'https://ludowik.github.io/lge/build/lovejs/lge-lovejs/lge')
end

function Parameter:addCaptureMenu()
    self:group('capture')

    self:space()
    self:action('pause', Graphics.noLoop)
    self:action('1x frame', Graphics.redraw)
    self:action('resume', Graphics.loop)

    self:space()
    self:action('capture image', function ()
        captureImage()
    end)

    self:action('capture logo', function ()
        captureLogo()
    end)
end

function Parameter:openGroup(group)
    self:setStateForAllGroups('close', false)
    self.currentMenu = group
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
    newGroup.label = label

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

function Parameter:declareParameter(varName, initValue, callback)
    if type(varName) == 'string' and env[varName] == null then
        env[varName] = initValue
    
    elseif classnameof(varName) == 'Bind' and varName:get() == null then
        varName:set(initValue)
    end

    if callback then
        callback()
    end
end

function Parameter:space()
    local ui = UI()
    ui.fixedSize = vec2(0, 5)
    self.currentGroup:add(ui)
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

local function isVarName(varName)
    if type(varName) == 'string' or classnameof(varName) == 'Bind' then return true end
end

function Parameter:boolean(label, varName, initValue, callback)
    if not isVarName(varName) then varName, initValue, callback = label, varName, initValue end

    self:declareParameter(varName, initValue, callback)
    self.currentGroup:add(UICheck(label, varName, callback))
end

function Parameter:integer(label, varName, min, max, initValue, callback)
    if not isVarName(varName) then varName, min, max, initValue, callback = label, varName, min, max, initValue end

    self:declareParameter(varName, initValue or min, callback)
    local ui = UISlider(label, varName, min, max, callback)
    ui.intValue = true
    ui.incrementValue = 1
    self.currentGroup:add(ui)
    return ui
end

function Parameter:number(label, varName, min, max, initValue, callback)
    if not isVarName(varName) then varName, min, max, initValue, callback = label, varName, min, max, initValue end

    self:declareParameter(varName, initValue or min, callback)
    local ui = UISlider(label, varName, min, max, callback)
    ui.intValue = false
    ui.incrementValue = 0.2
    self.currentGroup:add(ui)
    return ui
end

function Parameter:draw(x, y)
    x = x or 0
    y = y or 0

    local innerMarge = 5
    self:layout(x, y + innerMarge)
    Scene.draw(self)
end

function captureImage()
    engine.parameter.visible = false
    love.graphics.captureScreenshot(function (imageData)
        imageData:encode('png', 'image/'..env.__name..'.png')
        engine.parameter.visible = true
    end)
end

function captureLogo()
    local size = 1024
    local fb = FrameBuffer(size, size)
    render2context(fb,
        function ()
            sprite(env.sketch.fb, 0, 0, size, size, 0, (H-W)/2, W, W)
        end)
    fb:getImageData():encode('png', 'logo/'..env.__name..'.png')
    fb:release()
end
