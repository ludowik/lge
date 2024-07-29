require 'helper'
require 'syntax'

require 'engine'

-- @UITest

if love.filesystem.getIdentity() == 'update' then
    updateScripts(false, restart)
end
