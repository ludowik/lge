TimeGym = class() : extends(Sketch)

function TimeGym:init()
    Sketch.init(self)

    self.sound = love.audio.newSource('resources/beep.wav', 'static')

    self.scene = Scene()
    self.anchor = Anchor(6)
    
    function addInterface(Interface, label, i, j, m, n, callback)
        local interface = Interface(label, callback):attrib{
            position = self.anchor:pos(i, j),
            size = self.anchor:size(m, n),
            styles = {
                fontSize = 32,
                mode = CENTER,
            },
        }
        self.scene:add(interface)
        return interface
    end

    function addButton(label, i, j, m, n, callback)
        return addInterface(UIButton, label, i, j, m, n, callback)
    end

    self.cycleDuration = 5
    self.cycleCount = 3

    local j = 1
    addButton('<<', 0.5, j, 1, 1, function ()
        self.cycleDuration = max(15, self.cycleDuration - 15)
    end)
    addButton(Bind(self, 'cycleDuration'), 2, j, 2, 1, function ()
        self.cycleDuration = 60
    end)
    addButton('>>', 4.5, j, 1, 1, function ()
        self.cycleDuration = self.cycleDuration + 15
    end)
    
    j = 2.5
    addButton('<<', 0.5, j, 1, 1, function ()
        self.cycleCount = max(1, self.cycleCount - 1)
    end)
    addButton(Bind(self, 'cycleCount'), 2, j, 2, 1, function ()
        self.cycleCount = 5
    end)
    addButton('>>', 4.5, j, 1, 1, function ()
        self.cycleCount = self.cycleCount + 1
    end)

    j = 4
    self.state = 'stop'
    self.actionLabel = 'GO'

    self.currentTime = 0
    self.maxTime = 0
    self.currentCycle = 0
    self.lastCycle = 0
    
    addButton('Reset', 0.5, j, 1.5, 3, function ()
        self.state = 'stop'
        self.actionLabel = 'GO'

        self.currentTime = 0
        self.maxTime = self.cycleDuration
        self.currentCycle = 1
        self.lastCycle = self.cycleCount
    end)

    addButton(Bind(self, 'actionLabel'), 2.5, j, 3, 3, function ()
        if self.state == 'stop' then
            self.state = 'running'
            self.actionLabel = 'Pause'

            self.currentTime = 0
            self.maxTime = self.cycleDuration
            self.currentCycle = 1
            self.lastCycle = self.cycleCount

        elseif self.state == 'running' then
            self.state = 'paused'
            self.actionLabel = 'Continue'

        elseif self.state == 'paused' then
            self.state = 'running'
            self.actionLabel = 'Pause'
        end
    end).styles.fillColor = colors.red

    self.currentTime = 0.2
    addInterface(UIDelay, 'time', 0.5, 7.5, 5, 1).sketch = self
    addInterface(UICycle, 'count', 0.5, 9, 5, 1).sketch = self
end

function TimeGym:update(dt)
    if self.state == 'running' then

        local before = floor((self.maxTime - self.currentTime))
        local after = floor((self.maxTime - self.currentTime - dt))

        if before == after + 1 and before <= 3 then
            self.sound:setVolume(0.2*(4-before))
            self.sound:play()
            if before == 0 then
                repeat until not self.sound:isPlaying()
                self.sound:play()
            end
        end

        self.currentTime = self.currentTime + dt
        
        if self.currentTime >= self.maxTime then
            self.currentTime = 0
            self.currentCycle = self.currentCycle + 1
        end
        
        if self.currentCycle > self.lastCycle then
            self.state = 'stop'
            self.actionLabel = 'GO'
        end

    end 
end

function TimeGym:draw()
    background()
    self.scene:draw()
end

UIDelay = class() : extends(UI)

function UIDelay:init(label, sketch)
    UI.init(self, label)
    self.sketch = sketch
    self.styles:attrib{
        fillColor = Color(0.05, 0.4, 0.05, 0.7),
        timeColor = Color(0.1, 0.9, 0.1, 0.7),
    }
end

function UIDelay:draw()
    UI.draw(self)

    local pct = self.sketch.currentTime / self.sketch.maxTime
    local w = self.size.x * pct
    fill(self.styles.timeColor)
    rect(self.position.x, self.position.y, w, self.size.y)
end

UICycle = class() : extends(UI)

function UICycle:init(label, sketch)
    UI.init(self, label)
    self.sketch = sketch
    self.styles:attrib{
        fillColor = Color(0.05, 0.05, 0.4, 0.7),
        timeColor = Color(0.1, 0.1, 0.9, 0.7)
    }
end

function UICycle:draw()
    UI.draw(self)

    local pct = (self.sketch.currentCycle-1) / self.sketch.lastCycle
    local w = self.size.x * pct
    fill(self.styles.timeColor)
    rect(self.position.x, self.position.y, w, self.size.y)
end