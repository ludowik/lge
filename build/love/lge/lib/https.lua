if getOS() == 'web' then return end

local https = require 'https'

function request(url, success, fail, parameterTable)
    local code, result, headers = https.request(url, {
        method = 'GET',
        cache = 'reload',
        timeout = 30,
    })
    
    if code == 200 then
        if success then 
            success(result, code, headers)
        end
        return true

    else        
        if fail then
            fail(result, code, headers)
        end
        return false
    end
end
