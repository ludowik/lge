function updateScripts(fromGit, onSuccess)
    local url 
    if fromGit then
        url = 'https://ludowik.github.io/lge'

    else
        local ip = getSetting('ip', 32)
        url = 'http://192.168.1.'..ip..':8080'
    end
    
    url = url..'/build/love/lge.love'
    
    return request(url,
        function (result, code, headers)
            local identity = love.filesystem.getIdentity()
            love.filesystem.setIdentity('lge')
            love.filesystem.write('lge.love', result)
            love.filesystem.setIdentity(identity)
            onSuccess = onSuccess or restart
            if onSuccess then onSuccess() end
        end,
        function (result, code, headers)
            log(result, code, headers)
        end)
end
