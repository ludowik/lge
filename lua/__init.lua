require 'lua.info'
require 'lua.debug'
require 'lua.require'
require 'lua.string'
require 'lua.iter'
require 'lua.attrib'
require 'lua.class'
require 'lua.array'
require 'lua.index'
require 'lua.state'
require 'lua.settings'
require 'lua.grid'
require 'lua.function'
require 'lua.datetime'

function message(msg)
    love.window.showMessageBox('message', msg, {'OK'})
end
