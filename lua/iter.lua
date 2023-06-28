local __ipairs = ipairs
function ipairs(t, reverse)
    if reverse then
        return function ()
        end
    end
    return __ipairs(...)
end
