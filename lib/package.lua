function makezip()
    if getOS() == 'windows' then
        os.execute('.vscode/build.cmd')
        
    else
        os.execute('.vscode/build.sh')
    end
end

function updateScripts()
    --if getOS():inList{'osx', 'ios'} then
        local url = 'https://ludowik.github.io/Lge/build/lca.love'
        url = 'http://192.168.1.13:8080/build/lca.love'
        request(url, function (result, code, headers)
                local data = love.filesystem.write('lca.love', result)
            end,
            function (result, code, headers)
                print(headers)
            end)
    --end
end
