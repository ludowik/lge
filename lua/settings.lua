local settingsFileName = 'settings'
local settings

love.filesystem.createDirectory('data')
love.filesystem.createDirectory('logo')
love.filesystem.createDirectory('image')

function saveSettings()
    saveFile(settingsFileName, settings)
end

function saveData(fileName, table)
    saveFile('data/'..fileName, table)
end

function saveFile(fileName, table)
    love.filesystem.write(fileName, 'return '..Array.tolua(table))
end

function loadSettings()
    if getOS() == 'web' then return {} end

        return loadFile(settingsFileName) or {
        sketch = 'Hexagone'
    }
end

function loadData(fileName)
    return loadFile('data/'..fileName)
end

function loadFile(fileName)
    local ok, f = pcall(
        function ()
            return love.filesystem.load(fileName)
        end)
    if ok and type(f) == 'function' then
        return f()
    end
end

settings = loadSettings()

function setSetting(name, value)
    settings[name] = value
    saveSettings()
end

function getSetting(name, defaultValue)
    return settings[name] or defaultValue
end

setSetting('testBoolean', true)
setSetting('testNumber', 12.12)
setSetting('testString', 'valeur')
setSetting('testTable', {a = 'a'})
setSetting('testNil', nil)

assert(getSetting('testBoolean') == true)
assert(getSetting('testNumber') == 12.12)
assert(getSetting('testString') == 'valeur')
assert(getSetting('testTable').a == 'a')
assert(getSetting('testNil') == nil)

setSetting('testBoolean', nil)
setSetting('testNumber', nil)
setSetting('testString', nil)
setSetting('testTable', nil)
setSetting('testNil', nil)

assert(not setSetting('testBoolean'))
assert(not setSetting('testNumber'))
assert(not setSetting('testString'))
assert(not setSetting('testTable'))
assert(not setSetting('testNil'))
