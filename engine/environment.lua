Environment = class()

function Environment:init(name, itemPath, category)
    setmetatable(self, {
        __newindex = Environment.__newindex,
        __index = _G,
    })

    setfenv(0, self)
    
    local requirePath = itemPath:gsub('%/', '%.'):gsub('%.lua', '')
    require(requirePath, self)

    -- local requireFile = package.searchpath(requirePath, love.filesystem.getRequirePath()) 
    -- local chunk = loadfile(requireFile)
    -- assert(chunk)

    -- print(debug.setupvalue(chunk, 2, self))
    -- --setfenv(chunk, self)
    -- chunk(requirePath)

    self.__name = name
    self.__className = name:gsub('sketch%.', '')
    self.__category = category

    self.__sourceFile = itemPath
    self.__modtime = love.filesystem.getInfo(itemPath).modtime

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
