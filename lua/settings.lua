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

function setSettings(name, value)
    settings[name] = value
    saveSettings()
end

function getSettings(name, defaultValue)
    return settings[name] or defaultValue
end

setSettings('testBoolean', true)
setSettings('testNumber', 12.12)
setSettings('testString', 'valeur')
setSettings('testTable', {a = 'a'})
setSettings('testNil', nil)

assert(getSettings('testBoolean') == true)
assert(getSettings('testNumber') == 12.12)
assert(getSettings('testString') == 'valeur')
assert(getSettings('testTable').a == 'a')
assert(getSettings('testNil') == nil)

setSettings('testBoolean', nil)
setSettings('testNumber', nil)
setSettings('testString', nil)
setSettings('testTable', nil)
setSettings('testNil', nil)

assert(not setSettings('testBoolean'))
assert(not setSettings('testNumber'))
assert(not setSettings('testString'))
assert(not setSettings('testTable'))
assert(not setSettings('testNil'))
