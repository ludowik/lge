require 'engine'

if love.filesystem.getIdentity() == 'update' then
    message('update')
    updateScripts(false, restart)
end
