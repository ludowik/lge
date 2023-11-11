Instrument = class()

function Instrument:init()
    self.objects = Array{
        [love] = true,
        [love.graphics] = true,
        [love.timer] = true,
        [love.font] = true,
        [lldebugger] = true,
        [debug] = true,
        [Instrument] = true,
        [self] = true,
        [coroutine] = true,
        [io] = true,
        [string] = true,
        [table] = true,
    }

    self.functions = Array{
    }

    self:scanFunctions(_G, '_G')
    --self:instrumentFunctions(_G)

    log('Instrumented functions', #self.functions)

    self.level = 0
    self.columnSize = 0
    self.calls = {}
end

function Instrument:scanFunctions(t, tname)
    if self.objects[t] then return end
    self.objects[t] = true

    for k,v in pairs(t) do
        if self:isFunction(tname, k) then
            if type(v) == 'function' then
                local ref = {
                    parent = t,
                    parentName = tname,
                    name = k,
                    func = v,
                }
                self:resetFunction(ref)
                
                self.functions:add(ref)

            elseif type(v) == 'table' then
                self:scanFunctions(v, k)
            end
        end
    end
end

function Instrument:resetFunction(ref)
    ref.frames = 0
    ref.countByFrame = 0
    ref.countByFrameAvg = 0
    ref.countTotal = 0
    ref.elapsedTimeByFrame = 0
    ref.elapsedTimeByFrameAvg = 0
    ref.elapsedTime = 0
    ref.elapsedTimeTotal = 0
    ref.deltaTime = 0
    ref.deltaTimeAvg = 0
end

function Instrument:isFunction(tname, name)
    return type(name) == 'string' and
        not (name):inList(Instrument.systemfunctions) and
        not (tname..'.'..name):inList(Instrument.systemfunctions)
end

function Instrument:instrumentFunctions(t)
    for _,ref in ipairs(self.functions) do
        ref.parent[ref.name] = function (...)
            -- log(string.tab(self.level)..scriptLink(3), ref.parentName..'.'..ref.name)
            -- self.level = self.level + 1
            local startTime, endTime, innerTime, results, calls

            innerTime = 0
            startTime = love.timer.getTime()
            do 
                table.insert(self.calls, ref)
                calls = self.calls
                self.calls = {}

                results = { ref.func(...) }
                
                for _,v in ipairs(self.calls) do
                    innerTime = innerTime + v.elapsedTime
                end
                self.calls = calls                

                ref.countByFrame = ref.countByFrame + 1
            end
            endTime = love.timer.getTime()

            ref.elapsedTime = endTime - startTime - innerTime
            ref.elapsedTimeByFrame = ref.elapsedTimeByFrame + ref.elapsedTime
            
            -- self.level = self.level - 1

            return unpack(results)
        end
    end
end

function Instrument:update(dt)
    for _,ref in ipairs(self.functions) do
        if ref.countByFrame > 0 then
            ref.deltaTime = ref.elapsedTimeByFrame / ref.countByFrame
            
            ref.elapsedTimeTotal = ref.elapsedTimeTotal + ref.elapsedTimeByFrame
            ref.countTotal = ref.countTotal + ref.countByFrame
            ref.frames = ref.frames + 1

            ref.elapsedTimeByFrameAvg = ref.elapsedTimeTotal / ref.frames
            ref.countByFrameAvg = ref.countTotal / ref.frames
            ref.deltaTimeAvg = ref.elapsedTimeTotal / ref.countTotal
            
            ref.elapsedTimeByFrame = 0
            ref.countByFrame = 0
        end
    end
end

function Instrument:reset()
    for _,ref in ipairs(self.functions) do
        self:resetFunction(ref)
    end
end

function Instrument:release()
    self:reports()
end

function Instrument:reports()
    self.functions:sort(function (a, b)    
        return a.elapsedTimeByFrameAvg > b.elapsedTimeByFrameAvg
    end)

    log('Called Functions', self.functions:count(function (a) return a.countTotal > 0 end))

    for i=1,10 do
        local ref = self.functions[i]
        log(ref.parentName..'.'..ref.name, string.format('{deltaTimeAvg} * {countByFrameAvg} = {elapsedTimeByFrameAvg}', self.functions[i]))
    end
end

function Instrument:draw()
    screenBlur(0.75)

    fontName('arial')
    fontSize(15)

    self.functions:sort(function (a, b)    
        return a.elapsedTimeByFrameAvg > b.elapsedTimeByFrameAvg
    end)

    textPosition(engine.parameter.items[4].items[1].size.y*2)

    for i=1,25 do
        local ref = self.functions[i]

        local y = textPosition()
        local w, h = text(ref.parentName..'.'..ref.name, 0, y)

        self.columnSize = min(max(self.columnSize , w), W/2)

        text(string.format('%.5f * %d = %.5f',
            self.functions[i].deltaTimeAvg,
            self.functions[i].countByFrameAvg,
            self.functions[i].elapsedTimeByFrameAvg), self.columnSize, y)
    end
end

Instrument.systemfunctions = {
    'loaders',
    'assert',
    'error',
    'warning',
    'log',
    'setmetatable',
    'getmetatable',
    'require',
    'requireLib',
    'scriptLink',
    'scriptPath',
    'scriptName',
    'setfenv',
    'class',
    'type',
    'pairs',
    'ipairs',
    'unpack',
    'tonumber',
    'tostring',
    'print',
    'getTime',
    'sleep',
    'xpcall',
    'present',
    'setup',
    'initMode',
    'setMode',
    'load',
    'reload',
    'declareSketches',
    'declareSketch',
    'setSketch',
    'setCurrentSketch',
    'Engine.update',
    'Engine.draw',
}
