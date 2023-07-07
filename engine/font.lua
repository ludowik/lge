FontManager = class()

function FontManager.setup()
    FontManager.fonts = Array()
end

function fontSize(size)
    if FontManager.fonts[size] == nil then
        FontManager.fonts[size] = love.graphics.newFont(size)
    end
    love.graphics.setFont(FontManager.fonts[size])
end
