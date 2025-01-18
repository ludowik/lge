local settingsFileName = 'settings'
local settings, appSettings

class().setup = function ()
    love.filesystem.createDirectory('data')
    love.filesystem.createDirectory('logo')
    love.filesystem.createDirectory('image')

    settings = loadSettings()
    appSettings = {}
end

function saveSettings()
    saveFile(settingsFileName, settings)
end

function saveData(fileName, table)
    saveFile('data/'..fileName, table)
end

function saveFile(fileName, table)
    fileName = (fileName..'.lua'):lower()
    love.filesystem.write(fileName, 'return '..Array.tolua(table))
end

function loadSettings()
    return loadFile(settingsFileName) or {
        sketch = 'Hexagone'
    }
end

function loadData(fileName)
    return loadFile('data/'..fileName)
end

function loadFile(fileName)
    fileName = (fileName..'.lua'):lower()
    local ok, f = pcall(
        function ()
            return love.filesystem.load(fileName)
        end)
    if ok and type(f) == 'function' then
        return f()
    end
end

function setSetting(name, value)
    settings[name] = value
    saveSettings()
end

function getSetting(name, defaultValue)
    if settings[name] == nil then return defaultValue end
    return settings[name]
end

function setAppSetting(name, value)
    appSettings[env.sketch.__className] = appSettings[env.sketch.__className] or loadFile(env.sketch.__className) or {}
    appSettings[env.sketch.__className][name] = value
    saveFile(env.sketch.__className, appSettings[env.sketch.__className])
end

function getAppSetting(name, defaultValue)
    appSettings[env.sketch.__className] = appSettings[env.sketch.__className] or loadFile(env.sketch.__className) or {}
    if appSettings[env.sketch.__className][name] == nil then return defaultValue end
    return appSettings[env.sketch.__className][name]
end

class().unitTest = function ()
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
end
