require 'engine'

if love.filesystem.getIdentity():lower() == 'update' then
    setSetting('sketch', 'fetch')
end


Performance.timeit('iterate', function()
        for i=1,10000 do
        end
    end)

Performance.timeit('iterate with range', function()
    for i in range(10000) do
    end
end)