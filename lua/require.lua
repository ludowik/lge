local function transformCode(code)
    local pattern = "([%w%.%:]+)%s*%?(.-)\n"
    local function replaceMatch(variable, code)
        return string.format("if %s then %s%s end\n", variable:gsub(':', '.'), variable, code)
    end

    local transformedCode, replacements = string.gsub(code, pattern, replaceMatch)
    return transformedCode
end

local customLoader = function(moduleName)
    local modulePath = string.gsub(moduleName, "%.", "/")
    for path in string.gmatch(package.path, "([^;]+)") do
        local filePath = string.gsub(path, "%?", modulePath)
        local file = io.open(filePath, "rb")
        if file then
            local content = assert(file:read("*a"))
            local transformedContent = transformCode(content)
            return assert(loadstring(transformedContent, moduleName))
        end
    end
    return "Unable to load file " .. moduleName
end

table.insert(package.loaders, 1, customLoader)
