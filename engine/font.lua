FontManager = class()

function FontManager.setup()
    FontManager.fonts = Array()
end

function FontManager.getFont()
    local fontName = FontManager.fontName or ''
    local fontSize = FontManager.fontSize or 22
    
    local ref = fontName..'.'..fontSize
    if not FontManager.fonts[ref] then
        if fontName ~= '' then
            local fontPath = 'resources'..'/'..fontName..'.ttf'
            FontManager.fonts[ref] = love.graphics.newFont(fontPath, fontSize)
        else
            FontManager.fonts[ref] = love.graphics.newFont(fontSize)
        end
    end
    return FontManager.fonts[ref]
end

function fontName(name)
    if name then
        FontManager.fontName = name
    end
end

function fontSize(size)
    if size then
        FontManager.fontSize = size
    end
end
