FontManager = class()

function FontManager.setup()
    FontManager.fonts = Array()
    FontManager.path = 'resources/fonts'
end

function FontManager.getFont()
    local fontName = FontManager.fontName or ''
    local fontSize = FontManager.fontSize or 22

    fontSize = fontSize * devicePixelRatio
    
    local ref = fontName..'.'..fontSize
    if not FontManager.fonts[ref] then
        if fontName ~= '' then
            local fontPath = FontManager.path..'/'..fontName..'.ttf'
            FontManager.fonts[ref] = love.graphics.newFont(fontPath, fontSize)
        else
            FontManager.fonts[ref] = love.graphics.newFont(fontSize)
        end
    end
    return FontManager.fonts[ref]
end

function fontName(name)
    if name then
        FontManager.fontName = name:lower()
    end
    return FontManager.fontName
end

function fontSize(size)
    if size then
        FontManager.fontSize = size
    end
    return FontManager.fontSize
end
