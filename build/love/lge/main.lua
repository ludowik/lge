require 'engine'

if love.filesystem.getIdentity() == 'update' then
    updateScripts(false, restart)
end

-- dir('resources/fonts'):foreach(function (fname, index)
--     os.rename('resources/fonts/'..fname, 'resources/fonts/'..fname:lower())
-- end)

--exit()
