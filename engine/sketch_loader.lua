function load(reload)
    if getOS() == 'web' then
        local sketchesList = require 'engine.sketch_list'
        declareSketches(sketchesList)
    else
        declareSketches(nil, reload)
        --loadSketches()
    end
    
    classSetup()
    classUnitTesting()
    
    if getSetting('assertLoadIsKO') then
        processManager:setSketch('sketches', false)
    else
        setSetting('assertLoadIsKO', true)
        if not processManager:setSketch(getSetting('sketch', 'sketches')) then
            processManager:next()
        end
    end
    setSetting('assertLoadIsKO', nil)
end

local environments = nil
environmentsList = nil

function enumSketches()
    local list = Array()

    local function scan(path, category)
        local directoryItems = love.filesystem.getDirectoryItems(path)
        for _,itemName in ipairs(directoryItems) do
            local name = itemName:gsub('%.lua', '')
            local filePath = path..'/'..itemName

            local info = love.filesystem.getInfo(filePath)
            if info.type == 'directory' then
                local infoInit = love.filesystem.getInfo(filePath..'/'..'__init.lua')
                if infoInit then
                    list:add{name=name, filePath=filePath, category=category}
                else
                    scan(filePath, itemName)
                end
            else
                list:add{name=name, filePath=filePath, category=category}
            end
        end
    end
    
    scan('sketch')

    return list
end

function declareSketches(list, reload)
    list = list or enumSketches()

    environments = Array()
    for i,v in ipairs(list) do
        declareSketch(v.name, v.filePath, v.category, reload)
    end

    environmentsList = Array()
    for k,env in pairs(environments) do
        environmentsList:add(env)
    end
    environmentsList:sort(function (a, b)
        return (a.__category or '')..'.'..a.__name < (b.__category or '')..'.'..b.__name
    end)

    return list
end

function declareSketch(name, filePath, category, reload)    
    environments = environments or Array()

    if reload then
        local requirePath = filePath:gsub('%/', '%.'):gsub('%.lua', '')
        environments[requirePath] = nil
        for k,v in pairs(package.loaded) do
            if k:startWith(requirePath) then
                package.loaded[k] = nil
            end
        end
    end
    
    if environments[name] then return environments[name] end

    local env = Environment(name, filePath, category)
    
    for k,v in pairs(env) do
        if isSketch(v) then
            _G[k] = v
            v.env = env
            env.__sketch = v
            break
        end
    end

    if env.__sketch or env.setup or env.draw then
        environments[name] = env
        processManager:add(env)
    end
    
    return env
end

function isSketch(klass)
    if klass == Sketch then return true end
    if klass == nil or type(klass) ~= 'table' or klass.__inheritsFrom == nil then return false end
    return isSketch(klass.__inheritsFrom[1])
end

function loadSketches()
    for k,env in ipairs(environmentsList) do
        loadSketch(env)
    end
end

function loadSketch(env)
    if env.sketch then return end

    _G.env = env

    if env.__sketch then
        if env.__sketch.setup then
            env.__sketch.setup()
        end
        
        env.sketch = env.__sketch()
        env.sketch.env = env

    elseif env.setup or env.draw then
        env.sketch = Sketch()
        env.sketch.env = env

        env.sketch.__className = env.__className
        
        local function encapsulate(fname)
            if env[fname] then
                env.sketch[fname] = function (_, ...) return env[fname](...) end
            end
        end

        for _,fname in ipairs({
            'setup',
            'release',
            'pause',
            'resume',
            'resize',
            'update',
            'frame',
            'draw',
            'autotest',
            'mousepressed',
            'mousemoved',
            'mousereleased',
            'click',
            'keypressed',
            'wheelmoved',
        }) do
            encapsulate(fname)
        end

        if env.sketch.setup then
            env.sketch:setCanvas(true)
            env.sketch:setup()
            env.sketch:resetCanvas()
        end
    end
end

function saveSketchesList()
    if getOS() ~= 'osx' and getOS() ~= 'windows' then return end
    
    local sketchesList = 'return {' .. NL
    environmentsList:foreach(function (env)
        if env.__category then
            if  not env.__category:inList{'3d', 'pixel art', 'shader art'} and
                not env.__name:inList{'geojson', 'worley_noise', 'myline', 'micro', 'mouse'}
            then
                sketchesList = sketchesList .. TAB .. ("{name='{__name}', filePath='{__requirePath}', category='{__category}'},"):format(env) .. NL
            end
        else
            sketchesList = sketchesList .. TAB .. ("{name='{__name}', filePath='{__requirePath}'},"):format(env) .. NL
        end
    end)
    sketchesList = sketchesList  .. '}'

    local f = io.open('engine/sketch_list.lua', 'wt')
    if f then
        f:write(sketchesList)
        f:close()
    end
end
