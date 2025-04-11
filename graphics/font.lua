FontManager = class()

function FontManager.setup()
    FontManager.fonts = Array()
    FontManager.path = 'resources/fonts'

    DEFAULT_FONT_NAME = getSetting('DEFAULT_FONT_NAME', 'arial')
    
    DEFAULT_FONT_SIZE = getSetting('DEFAULT_FONT_SIZE', 24)
    SMALL_FONT_SIZE = floor(DEFAULT_FONT_SIZE * 2 / 3)
end

function FontManager.newFont(...)
    return love.graphics.newFont(...)
end

function FontManager.getFont()
    local fontName = FontManager.fontName or ''
    local fontSize = FontManager.fontSize or 22

    fontSize = fontSize
    
    local ref = fontName..'.'..fontSize
    if not FontManager.fonts[ref] then
        if fontName ~= '' then
            local fontPath = FontManager.path..'/'..fontName..'.ttf'
            FontManager.fonts[ref] = FontManager.newFont(fontPath, fontSize)
        else
            FontManager.fonts[ref] = FontManager.newFont(fontSize)
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
