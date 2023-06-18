https = require 'https'

function request(url, success, fail, parameterTable)
    local result, code, headers = https.request(url)

    if result then
        if success then 
            success(result, code, headers)
        end
        
    else        
        if fail then
            fail(result, code, headers)
        end
    end

end
