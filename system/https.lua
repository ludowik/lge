https = require 'https'

function request(url, success, fail, parameterTable)
    local result, code, headers = https.request(url)

    if result then
        local tempFile = love.filesystem.getAppdataDirectory()
        local data = love.filesystem.write(tempFile..'/LOVE/Lge/coucou.txt', 'coucou')
        local data = love.filesystem.write(tempFile..'/LOVE/Lge/lca.love', code)

        print(tempFile..'/LOVE/Lge/lca.love')
        print(data)

        if success then 
            success(data, code, headers)
        end
        
    else        
        if fail then
            fail(result, code, headers)
        end
    end

end
