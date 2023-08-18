local function transformCode(code)
    return code
end

local customLoader = function(moduleName)
    local modulePath = string.gsub(moduleName, "%.", "/")
    for path in string.gmatch(package.path, "([^;]+)") do
        local filePath = string.gsub(path, "%?", modulePath)
        local file = io.open(filePath, "rb")
        if file then
            local content = assert(file:read("*a"))
            local transformedContent = transformCode(content)
            return assert(loadstring(transformedContent, "@"..filePath))
        end
    end
    return "Unable to load file " .. moduleName
end

--table.insert(package.loaders, 2, customLoader)
