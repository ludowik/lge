function io.read(path)
    local file = io.open(path, 'r')
    if file then
        local content = file:read('*a')
        file:close()
        return content
    end
end

function lexer(source)
    local tokens = {}

    -- magic characters :  ( ) . % + - * ? [ ^ $
    local patterns = {
        {'comment'    , '%-%-%[%[.-%]%]'},
        {'comment'    , '(%-%-.-)\n'},
        {'new line'   , '\n+\r+'},
        {'tab'        , '    '},
        {'space'      , '%s+'},
        {'string'     , '%b""'},
        {'string'     , "%b''"},
        {'string'     , '%[%[.-%]%]'},
        {'concatenate', '%.%.'},
        {'id'         , '[%a_]+'},
        {'hexa'       , '0x%x+'},
        {'number'     , '%d+'},
        {'operator'   , '[%%%^%+%-%*%/]'},
        {'parenthese' , '[%(%)]'},
        {'punctuation', '[%.:{}%[%],;]'},
        {'count'      , '[#]'},
        {'compare'    , '<'},
        {'compare'    , '<='},
        {'compare'    , '>'},
        {'compare'    , '>='},
        {'equal'      , '=='},
        {'distinct'   , '~='},
        {'assign'     , '='},
    }

    local keywords = {
        'local',
        'function',
        'if', 'then', 'elseif', 'else', 'end',
        'for', 'in', 'do', 'break',
        'while',
        'repeat', 'until',
        'return',
        'true', 'false'
    }        

    function searchForPattern(source, pattern, pos)
        local search = '^'..pattern[2]

        local startPos, endPos = string.find(source, search, pos)

        if startPos == pos then

            local token = string.match(source, search, pos)
            table.insert(tokens, {
                    type = pattern[1],
                    token = token
                })

            return endPos - startPos + 1

        end
        return 0
    end

    local pos, find = 1, true
    while find do
        find = false

        for i,keyword in ipairs(keywords) do
            len = searchForPattern(source, {'keyword', keyword}, pos)
            if len > 0 then
                pos = pos + len
--                source = source:mid(len+1)
                find = true
                break
            end
        end

        for i,pattern in ipairs(patterns) do
            len = searchForPattern(source, pattern, pos)
            if len > 0 then
                pos = pos + len
--                source = source:mid(len+1)
                find = true
                break
            end
        end
    end

    local list = {}
    for i,token in ipairs(tokens) do
        if token.type == 'new line' then
            table.insert(list, '\n?\r?')
            
        elseif token.type == 'tab' then
            table.insert(list, '    ')
            
        elseif token.type == 'space' then
            table.insert(list, ' ')
        else
            --table.insert(list, '['..token.type..':'..token.token..']')
            table.insert(list, token.token)
        end
    end
    print(table.concat(list))
end
