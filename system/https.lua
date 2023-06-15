local https = require 'https'

function https.request(url, success, fail, parameterTable)
    local result, code, headers = https.request(url)

    if result then
        local tempFile = love.filesystem.getAppdataDirectory()
        local data = love.filesystem.write(tempFile, result)

        if headers['content-type'] and headers['content-type']:startWith('image') then
            data = image('data')
        end

        if success then 
            success(data, code, headers)
        end
        
    else        
        if fail then
            fail(result, code, headers)
        end
    end

end
