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

    self.delta = {}
    for k,v in pairs(target) do
        self.delta[k] = (target[k] - source[k]) / delay
    end

    self.source = source
    self.origin = Array.clone(source)
    self.target = target
    self.delay = delay
    self.elapsed = 0
    self.callback = callback or nilf

    self.state = 'wait'
end

function Tween:update(dt)
    if self.state ~= 'running' then return end

    self.elapsed = min(self.delay, self.elapsed + dt)

    for k,v in pairs(self.target) do
        self.source[k] = self.origin[k] + (self.target[k] - self.origin[k]) * (self.elapsed / self.delay)
    end

    if self.elapsed >= self.delay then
        -- ensure source = target
        -- for k,v in pairs(self.target) do
        --     self.source[k] = self.target[k]
        -- end

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
    self.callback()
    self.state = 'dead'
end

function animate(source, target, delay, callback)
    local tween = Tween(source, target, delay, callback)
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
    }

    Tween(test, {a=2}, 2, function () print('a', test.a) end):play()

    sequence(
        Tween(test, {b=1}, 1, function () print('b', test.b) end),
        Tween(test, {c=1}, 1, function () print('c', test.c) end)
    )
end
