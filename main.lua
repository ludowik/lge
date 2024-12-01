require 'engine'

if love.filesystem.getIdentity() == 'update' then
    setSetting('sketch', 'fetch')
end
