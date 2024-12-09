require 'engine'

if love.filesystem.getIdentity():lower() == 'update' then
    setSetting('sketch', 'fetch')
end
