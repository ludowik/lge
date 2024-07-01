require 'engine'

if love.filesystem.getIdentity() == 'update' then
    updateScripts(false, restart)
end
