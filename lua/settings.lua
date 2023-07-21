local settingsFileName = 'settings'

local settings

function saveSettings()
    saveFile(settingsFileName, settings)
end

function saveFile(fileName, table)
    love.filesystem.write(fileName, 'return '..Array.tolua(table))
end

function loadSettings()
    return readFile(settingsFileName) or {
        sketch = 'Hexagone'
    }
end

function readFile(fileName)
    local ok, f = pcall(function () return love.filesystem.load(fileName) end)
    if ok and f then
        return f()
    end
end

function updateSettings()
    local needUpdate = false
    if settings.sketch ~= processManager:current().__className then
        settings.sketch = processManager:current().__className
        needUpdate = true
    end
    if needUpdate then
        saveSettings()
    end
end

settings = loadSettings()

function setSettings(name, value)
    settings[name] = value
    saveSettings()
end

function getSettings(name)
    return settings[name]
end

setSettings('testBoolean', true)
setSettings('testNumber', 12.12)
setSettings('testString', 'valeur')
setSettings('testTable', {a = 'a'})
setSettings('testNil', nil)
