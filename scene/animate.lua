TweenManager = class() : extends(Node)

function TweenManager.setup()
    for k,v in pairs(tween.easing) do
        tween.easingFunctions:add(v)
    end
end

function TweenManager:update(dt)
    self:foreach(function (v) v:update(dt) end)
    self:removeIfTrue(function (v) return v.state == 'dead' end)
end

Tween = class()

tween = Array{
    easingFunctions = Array{},

    loop = Array{
        once = 'once',
        pingpong = 'pingpong',
    }
}

function Tween:init(source, target, delay, easingOrOptions, callback)
    if env and env.sketch then
        env.sketch.tweenManager:add(self)
    end

    local easing
    local loop
    
    if type(easingOrOptions) == 'table' then
        easing = easingOrOptions.easing
        loop = easingOrOptions.loop
    else
        easing = easingOrOptions
        loop = tween.loop.once
    end

    if tween.easing:keyOf(easing) == nil then
        callback = easing
        easing = tween.easing.linear
    end

    self.source = source
    self.target = target

    if type(delay) == 'table' then
        self.delayBeforeStart = delay.delayBeforeStart or 0
        self.delay = delay.delay
    else
        self.delayBeforeStart = 0
        self.delay = delay or 1
    end

    self.elapsed = 0

    self.easing = easing
    self.loop = loop

    self.callback = callback or nilf

    self.state = 'stop'
end

local function get(t, name)
    return t[name]
end

local function set(t, name, value)
    t[name] = value
end

function Tween:update(dt)
    if self.state ~= 'running' then return end

    if self.delayBeforeStart > 0 then
        self.delayBeforeStart = self.delayBeforeStart - dt
    else
        self.elapsed = min(self.delay, self.elapsed + dt)
    end

    for k,v in pairs(self.target) do
        local t = self.elapsed
        local b = get(self.origin, k)
        local c = get(self.target, k) - b
        local d = self.delay
        
        set(self.source, k, self.easing(t, b, c, d))
    end

    if self.elapsed >= self.delay then
        -- ensure source = target
        for k,v in pairs(self.target) do
            set(self.source, k, get(self.target, k))
        end

        self:finalize(self.elapsed - self.delay)
    end
end

function Tween:play()
    self.origin = Array.clone(self.source)
    self.state = 'running'
end

function Tween:stop()
    self.state = 'stop'
end

function Tween:reset()
    self.state = 'running'
    
    for k,v in pairs(self.target) do
        set(self.source, k, get(self.origin, k))
    end
    self.elapsed = 0
end

function Tween:finalize(dt)
    self.callback(self)

    if self.loop == tween.loop.pingpong then
        self.target = self.origin
        self.elapsed = 0

        self:play()

        if dt and dt > 0 then
            self:update(dt)
        end
    else
        self.state = 'dead'
    end
end

function animate(source, target, delay, easing, callback)
    local tween = Tween(source, target, delay, easing, callback)
    tween:play()
    return tween
end

function timer(delay, callback)
    local tween = Tween({}, {}, delay, tween.easing.linear, callback)
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
        Tween(test, {b=1}, 1, tween.easing.linear, function () assert(test.b == 1) end),
        Tween(test, {c=1}, 1, tween.easing.linear, function () assert(test.c == 1) end)
    )

    timer(3, function (t)
    end)
end
