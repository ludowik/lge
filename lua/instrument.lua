Instrument = class()

function Instrument:init()
    self:avoidReferences()
    self:scanFunctions()
    self:instrumentFunctions(_G)

    self.level = 0
    self.columnSize = 0
end

function Instrument:scanFunctions()
    self.functions = Array()
    self:scanFunctionsProc(_G, '_G', {})
end

function Instrument:scanFunctionsProc(t, tname, objects)
    if objects[t] then return end
    objects[t] = true

    for k,ref in pairs(t) do
        if self:isAvailableReference(t, k, ref) then
            if type(ref) == 'function' then
                self.functions:add(Instrument.Function(t, tname, k, ref))

            elseif type(ref) == 'table' then
                self:scanFunctionsProc(ref, k, objects)
            end
        end
    end
end

Instrument.Function = class()

function Instrument.Function:init(t, tname, k, v)
    self.parent = t
    self.parentName = tname
    self.name = k
    self.func = v

    self:reset()
end

function Instrument.Function:reset()
    self.frames = 0
    self.countByFrame = 0
    self.countByFrameAvg = 0
    self.countTotal = 0
    self.elapsedTimeByFrame = 0
    self.elapsedTimeByFrameAvg = 0
    self.elapsedTime = 0
    self.elapsedTimeTotal = 0
    self.deltaTime = 0
    self.deltaTimeAvg = 0
end

function Instrument:isAvailableReference(t, k, f)
    return (
            type(k) == 'string' and
        not Instrument.avoidModules[t] and
        not Instrument.avoidFunctions[f])
end

function Instrument:instrumentFunctions(t)
    local ipairs, insert, unpack, getTime = ipairs, table.insert, table.unpack, love.timer.getTime

    self.calls = {}

    for _,ref in ipairs(self.functions) do

        ref.parent[ref.name] = function (...)
            -- log(string.tab(self.level)..scriptLink(3), ref.parentName..'.'..ref.name)
            -- self.level = self.level + 1
            local startTime, innerTime, endTime, results, push_calls

            startTime = getTime()
            innerTime = 0

            do
                insert(self.calls, ref)
                push_calls = self.calls
                self.calls = {}

                results = { ref.func(...) }
                
                for _,v in ipairs(self.calls) do
                    innerTime = innerTime + v.elapsedTime
                end
                self.calls = push_calls                

                ref.countByFrame = ref.countByFrame + 1
            end

            endTime = getTime()

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
        ref:reset()
    end
end

function Instrument:draw()
    screenBlur(0.5)

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

Instrument.avoidFunctions = {
    print, log, message, warning, error,
    class, setmetatable, getmetatable, setfenv,
    ipairs, pairs,
    unpack,
    assert,
    type, tonumber, tostring,
    require, requireLib,
    xpcall,
}

Instrument.avoidModules = {
    Instrument,
    Instrument.Function,
    love,
    lldebugger, debug,
    coroutine,
}

function Instrument:avoidReferences()
    for i=1,#Instrument.avoidFunctions do
        local func = Instrument.avoidFunctions[i]
        if func then
            Instrument.avoidFunctions[func] = true
        end
    end
    
    for i=1,#Instrument.avoidModules do
        local module = Instrument.avoidModules[i]
        if module then
            Instrument.avoidModules[module] = true

            local function scanModule(module, objects)
                if objects[module] then return end
                objects[module] = true
                
                for _,f in pairs(module) do
                    if type(f) == 'function' then
                        Instrument.avoidFunctions[f] = true

                    elseif type(f) == 'table' then
                        scanModule(f, objects)
                    end
                end
            end

            scanModule(module, {})
        end
    end
end
