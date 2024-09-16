Environment = class() : extends(table)

function Environment:init(name, filePath, category)
    self.env = self

    setmetatable(self, {
        __newindex = Environment.__newindex,
        __index = _G,
    })

    local requirePath = filePath:gsub('%/', '%.'):gsub('%.lua', '')
    require(requirePath, self)

    self.__name = name
    self.__className = name:gsub('sketch%.', '')
    self.__category = category

    self.__filePath = filePath
    self.__requirePath = requirePath

    self.__modtime = love.filesystem.getInfo(filePath).modtime

    self.deltaTime = 0
    self.elapsedTime = 0

    self.frameCount = 0
end

function Environment.__newindex(self, key, ...)
    local result = rawset(self, key, ...)

    self.__ordered = self.__ordered or {}
    table.insert(self.__ordered, key)

    return result
end
