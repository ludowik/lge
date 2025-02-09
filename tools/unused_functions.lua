local overloads = {}

for name,f in pairs(_G) do
    if type(f) == 'function' then
        breakpoint(name=='rose')
        overloads[f] = {
            table = _G,
            name = name,
            f = f,
            called = 0,
        }
    end
end

for name,ref in pairs(overloads) do
    if not ref.overload and name ~= '__print' then
        ref.overload = true
        ref.table[ref.name] = function (...)
            ref.called = ref.called + 1
            return ref.f(...)
        end
    end
end

local quit = _G.quit
_G.quit = function ()
    console.clear()

    for name,ref in pairs(overloads) do
        if ref.called == 0 then
            breakpoint(name=='rose')
            print(ref.name)
        end
    end
    quit()
end

