NL = '\n'
TAB = '\t'

string.__format = string.format

function string.format(str, args, ...)
    if type(args) == 'table' then
        for i, v in ipairs(args) do
            str = str:gsub('{' .. i .. '}', tostring(v))
        end
        for k, v in pairs(args) do
            str = str:gsub('{' .. k .. '}', tostring(v))
        end
        return str
    end

    return string.__format(str, args, ...)
end

function string.formatNumber(value, sep, thousandSep)
    sep = sep or '.'

    value = tonumber(value)

    local intPart, decimalPart = tostring(value):match('(%d*)%.?(%d*)')

    local asString
    if decimalPart == '' then
        if thousandSep then
            local reverse, temp = intPart:reverse(), ''
            while reverse:len() > 0 do
                temp = temp..thousandSep..reverse:left(3)
                reverse = reverse:mid(4)
            end
            intPart = temp:mid(2):reverse()
        end
        asString = intPart
        
    else
        asString = intPart..sep..decimalPart
    end

    return asString
end

function string:inList(list)
    assert(type(list) == 'table')
    for _, v in pairs(list) do if v == self then return true end end
end

function string:startWith(text)
    return self:find(text) == 1
end

function string.contains(s, ...)
    local args = { ... }
    if #args == 1 and type(args[1]) == 'table' then
        args = args[1]
    end

    for i, v in ipairs(args) do
        if s:find(v) then
            return true
        end
    end
    return false
end

function string.findLast(s, txt)
    s = s:reverse()
    local i = s:find(txt)
    if i then
        return s:len() - i + 1
    end
end

function string:random()
    local i = randomInt(1, #self)
    return self:sub(i, i)
end

function string:quote()
    return '"' .. self .. '"'
end

function string.left(s, n)
    return s:sub(1, n)
end

function string.mid(s, i, n)
    if n then
        return s:sub(i, i + n - 1)
    else
        return s:sub(i)
    end
end

function string.right(s, n)
    return s:sub(-n)
end

function string.replace(s, from, to)
    local s = s:gsub(from, to)
    return s
end

function string.split(s, delimiter_, trim)
    trim = trim == nil and true or trim

    local result = {}
    local delimiter = delimiter_ or ","
    if delimiter == '.' then
        delimiter = '%.'
    end
    for match in (s .. delimiter_):gmatch("(.-)" .. delimiter) do
        if trim then
            match = match:trim()
        end
        table.insert(result, match)
    end
    return result
end

function string.join(t, delimiter)
    local result = ''
    for i, s in ipairs(t) do
        result = result .. tostring(s)
        if i < #t then
            result = result .. delimiter
        end
    end
    return result
end

function string.tab(level)
    local str = ''
    for i = 1, level do
        str = str .. '    '
    end
    return str
end

function string.trim(s)
    while string.find(s, '  ') do
        s = string.gsub(s, '  ', ' ')
    end
    return s:match '^()%s*$' and '' or s:match '^%s*(.*%S)'
end

function string.proper(s)
    local words = s:split(' ', true)
    for i, s in ipairs(words) do
        words[i] = words[i]:sub(1, 1):upper() .. s:sub(2):lower()
    end
    return string.join(words, ' ')
end

function string.unitTest()
    assert(('list'):inList { 'list' })
    assert(not ('not in list'):inList { 'list' })

    assert(string.lower('TEST') == 'test')
    assert(string.upper('test') == 'TEST')

    assert(string.left('test', 2) == 'te')
    assert(string.right('right', 2) == 'ht')

    assert(string.rep('t', 4) == 'tttt')

    assert(string.proper('test test') == 'Test Test')

    assert(string.startWith('test', 'te') == true)
    assert(string.startWith('test', 'et') == false)

    assert(string.contains('test', 'es') == true)
    assert(string.contains('test', 'et') == false)

    assert(string.replace('test', 'e', 'E') == 'tEst')

    assert(string.rep('a', 5) == 'aaaaa')
    assert(string.rep('ab', 2) == 'abab')

    assert(string.formatNumber(6546541.6465465) == '6546541.6465465')
    assert(string.formatNumber(.6465465, '.', ' ') == '0.6465465')
    assert(string.formatNumber(6465465) == '6465465')
    assert(string.formatNumber(6465465, '.', ' ') == '6 465 465')
    assert(string.formatNumber(5.6, ',') == '5,6')
    assert(string.formatNumber(0) == '0')

    assert(string.trim('        ') == '')
    assert(string.trim(' ab ') == 'ab')
    assert(string.trim(' a  b ') == 'a b')
    assert(string.trim(' a   b ') == 'a b')
    assert(string.trim(' a    b ') == 'a b')
end
