require 'engine'

if love.filesystem.getIdentity():lower() == 'update' then
    setSetting('sketch', 'fetch')
end

Performance.compare(
    'iterate', function()
        for i=1,10000 do
        end
    end,
    'iterate with range', function()
        for i in range(10000) do
        end
    end)
