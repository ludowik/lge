function isinteger(v)
    return v == floor(v)
end

function tointeger(number)
    return __floor(tonumber(number) or 0)
end

function toboolean(v)
    return v == 'true' and true or false
end

function tocolor(v)
    local r, g, b, a = v:match('r=(%d+), g=(%d+), b=(%d+), a=(%d+)')
    return color(
        tonumber(r),
        tonumber(g),
        tonumber(b),
        tonumber(a))
end

local unitsMemory = {'o', 'ko', 'mo', 'go', 'to'}

function convertMemory(size, index)
    if size == nil then return '?' end

    index = index or 1
    while size >= 1024 and index < #unitsMemory do
        size = size / 1024
        index = index + 1
    end
    return __format('%.1f', size)..' '..unitsMemory[index]
end

local unitsNumber = {'', 'milliers', 'millions', 'milliards', 'billion', 'billiard'}

function convertNumber(number)
    local index = 1
    while number >= 1000 and index < #unitsNumber do
        number = number / 1000
        index = index + 1
    end
    return __format('%.2f', number)..' '..unitsNumber[index]
end
