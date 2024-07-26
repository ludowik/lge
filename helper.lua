module(..., package.seeall)

local function load(moduleName)
    local errmsg = ''
    
    local modulePath = string.gsub(moduleName, "%.", "/")
    for path in string.gmatch(package.path, "([^;]+)") do
        local fileName = string.gsub(path, "%?", modulePath)

        local file = io.open(fileName, "rb")
        if file then
            -- Compile and return the module
            local contents = file:read("*a")
            contents = contents:gsub('global ', ' ')
            return assert(loadstring(assert(contents), fileName))
        end

        errmsg = errmsg.."\n\tno file '"..fileName.."' (checked with custom loader)"
    end
    return errmsg
end
table.insert(package.loaders, 1, load)

