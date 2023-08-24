function makezip()
    if getOS() == 'windows' then
        os.execute('.vscode\\build.cmd')
        
    else
        os.execute('.vscode/build.sh')
    end
end

function updateScripts(github)
    local url 
    if github then
        url = 'https://ludowik.github.io/lge'
    else
        url = 'http://192.168.1.13:8080'
    end

    url = url..'/build/lca.love'

    request(url,
        function (result, code, headers)
            local data = love.filesystem.write('lca.love', result)
        end,
        function (result, code, headers)
            print(result, code, headers)
        end)
end
