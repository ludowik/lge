local settingsFileName = 'settings'

function tolua(t)
    local code = 'return {'
    for k,v in pairs(t) do
        local serializeTypes = {
            boolean = tostring,
            number = tostring,
            string = function (v) return '"'..v..'"' end,
            table = function (v) return '"TODO"' end, 
        }

        if serializeTypes[type(v)] then
            code = code..'\n'    
            code = code..'\t'..k..' = '
            code = code..serializeTypes[type(v)](v)
            code = code..','
        end
    end

    code = code..'\n}'
    return code
end

function saveSettings()
    love.filesystem.write(settingsFileName, tolua(settings))
end

function loadSettings()
    local ok, f = pcall(function () return love.filesystem.load(settingsFileName) end)
    if ok and f then
        return f() or {}
    end

    return {
        sketch = 'Hexagone'
    }
end

settings = loadSettings()

function setSettings(name, value)
    settings[name] = value
    saveSettings()
end

setSettings('testBoolean', true)
setSettings('testNumber', 12.12)
setSettings('testString', 'valeur')
setSettings('testTable', {a = 'a'})
setSettings('testNil', nil)
