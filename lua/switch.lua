function switch(cases, default)
    for _,case in ipairs(cases) do
        if case[1] then return 
            case[2]
        end
    end
    return default
end
