TweenManager = class() : extends(Node)

function TweenManager.setup()
    tweenManager = TweenManager()
end

function TweenManager:update(dt)
    self:foreach(function (v) v:update(dt) end)
    self:removeIfTrue(function (v) return v.state == 'dead' end)
end

Tween = class()

function Tween:init(source, target, delay, callback)
    tweenManager:add(self)

    self.source = source
    self.origin = Array.clone(source)
    self.target = target

    if type(delay) == 'table' then
        self.delayBeforeStart = delay.delayBeforeStart
        self.delay = delay.delay
    else
        self.delayBeforeStart = 0
        self.delay = delay
    end

    self.elapsed = 0
    self.callback = callback or nilf

    self.state = 'wait'
end

function Tween:update(dt)
    if self.state ~= 'running' then return end

    if self.delayBeforeStart > 0 then
        self.delayBeforeStart = self.delayBeforeStart - dt
    else
        self.elapsed = min(self.delay, self.elapsed + dt)
    end

    for k,v in pairs(self.target) do
        self.source[k] = self.origin[k] + (self.target[k] - self.origin[k]) * (self.elapsed / self.delay)
    end

    if self.elapsed >= self.delay then
        -- ensure source = target
        for k,v in pairs(self.target) do
            self.source[k] = self.target[k]
        end

        self:finalize()
    end
end

function Tween:play()
    self.state = 'running'
end

function Tween:stop()
    self.state = 'dead'
end

function Tween:reset()
    self.state = 'running'
    -- TODO
end

function Tween:finalize()
    self.callback(self)
    self.state = 'dead'
end

function animate(source, target, delay, callback)
    local tween = Tween(source, target, delay, callback)
    tween:play()
    return tween
end

function timer(delay, callback)
    local tween = Tween({}, {}, delay, callback)
    tween:play()
    return tween
end

local function sequenceNext(callback, tweens, next)
    return function ()
        local result = callback() 
        if next <= #tweens then
            tweens[next]:play()
        end
        return result
    end
end

function sequence(...)
    local tweens = {...}
    for i,tween in ipairs(tweens) do
        tween.callback = sequenceNext(tween.callback, tweens, i+1)
    end

    if #tweens > 0 then
        tweens[1]:play()
    end
end

function TweenManager.unitTest()
    local test = {
        a = 0,
        b = 0,
        c = 0,
        d = 0,
    }

    animate(test, {a=2}, 2, function (t)
        assert(test.a == 2)
    end)

    sequence(
        Tween(test, {b=1}, 1, function () assert(test.b == 1) end),
        Tween(test, {c=1}, 1, function () assert(test.c == 1) end)
    )

    timer(3, function (t)
    end)
end
