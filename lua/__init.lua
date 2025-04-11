require 'lua.log'
require 'lua.debug'
require 'lua.require'

ffi = try_require 'ffi'

-- require 'lua.helper'
-- require 'lua.helper_syntax'

requireLib (..., {
    'table',
    'string',
    --'log',
    'os',
    'iter',
    'attrib',
    'class',
    'array',
    'buffer',
    'index',
    'state',
    'settings',
    'grid',
    'datetime',
    'eval',
    'argument',
    'instrument',
    'power',
    'memory',
    'quadtree',
    'octree',
    'dir',
    'id',
    'switch',
    'console',
})
