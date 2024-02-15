local grayScale = Color.grayScaleIntensity

function setup()
    source = Image('resources/images/joconde.png')
    target = FrameBuffer(source.width, source.height)

    parameter:action('Reset',
        function ()
            source = Image('resources/images/joconde.png')
            target = FrameBuffer(source.width, source.height)
        end)

    parameter:action('Flip image',
        function ()
            source, target = target, source
        end)

    parameter:action('Iso', function () setFilter(Image.Filter) end)
    parameter:action('Min', function () setFilter(Image.Filter.Min) end)
    parameter:action('Max', function () setFilter(Image.Filter.Max) end)
    parameter:action('Average', function () setFilter(Image.Filter.Average) end)
    parameter:action('Grayscale', function () setFilter(Image.Filter.Grayscale) end)
    parameter:action('Sort', function () setFilter(Image.Filter.Sort) end)
    parameter:action('Hue', function () setFilter(Image.Filter.Hue) end)
    parameter:action('Dithering', function () setFilter(Image.Filter.Dithering) end)
    parameter:action('Edge', function () setFilter(Image.Filter.Edge) end)
    parameter:action('Compose', function () setFilter(Image.Filter.Compose) end)

    parameter:link('Url', 'https://medium.com/@aryamansharda/how-image-edge-detection-works-b759baac01e2')

    setFilter(Image.Filter.Grayscale)
end

function getPixel(source, x, y, clr)
    if (
        0 <= x and x < source.width and
        0 <= y and y < source.height )
    then
        return Color(source:get(x, y, clr))
    end
    return colors.black
end

function setPixel(source, x, y, clr)
    if (
        0 <= x and x < source.width and
        0 <= y and y < source.height )
    then
        source:set(x, y, clr)
    end
end

Image.Filter = class()

function Image.Filter:init()
end

function Image.Filter:run(source, target)
    self.source = source
    self.target = target

    for y=0,source.height-1 do
        for x=0,source.width-1 do
            local res = self:fragment(x, y, getPixel(self.source, x, y))
            if res then
                self.target:set(x, y, res)
            end
        end
        if y % 10 == 0 then
            coroutine.yield()
        end
    end
end

function Image.Filter:fragment(x, y, clr)
    return clr
end

Image.Filter.MinMax = class() : extends(Image.Filter)

function Image.Filter.MinMax:init()
    Image.Filter.init(self)
    self.n = 5
end

function Image.Filter.MinMax:minmax(x, y, operation, ref)
    local n = self.n or 3

    local i = floor((n-1)/2)

    local clr = Color(ref)
    for xi=x-i,x+i do
        for yi=y-i,y+i do
            clr = operation(clr, getPixel(self.source, xi, yi) or ref)
        end
    end

    self.target:set(x, y, clr)
end

Image.Filter.Min = class() : extends(Image.Filter.MinMax)

function Image.Filter.Min:init()
    Image.Filter.MinMax.init(self)
end

function Image.Filter.Min:fragment(x, y)
    self:minmax(x, y, Color.min, white)
end

Image.Filter.Max = class() : extends(Image.Filter.MinMax)

function Image.Filter.Max:init()
    Image.Filter.MinMax.init(self)
end

function Image.Filter.Max:fragment(x, y)
    self:minmax(x, y, Color.max, black)
end

Image.Filter.Average = class() : extends(Image.Filter.MinMax)

function Image.Filter.Average:init()
    Image.Filter.MinMax.init(self)
end

function Image.Filter.Average:fragment(x, y)
    self:minmax(x, y, Color.avg, white)
end

Image.Filter.Dithering = class() : extends(Image.Filter)

function Image.Filter.Dithering:init()
    self.pct7 = 7 / 16
    self.pct3 = 3 / 16
    self.pct5 = 5 / 16
    self.pct1 = 1 / 16

    self.old = Color()
    self.new = Color()

    self.quantificationError = Color()

    self.clr = Color()
end

function Image.Filter.Dithering:fragment(x, y)
    -- old
    getPixel(self.source, x, y, self.old)

    -- new
    grayScale(self.old, self.new)

    local n = 4
    self.new.r = round(self.new.r * n) / n
    self.new.g = round(self.new.g * n) / n
    self.new.b = round(self.new.b * n) / n

    -- error
    self.quantificationError.r = self.old.r - self.new.r
    self.quantificationError.g = self.old.g - self.new.g
    self.quantificationError.b = self.old.b - self.new.b

    -- set color
    self.target:set(x, y, self.new)

    -- report error
    local function reportError(x, y, pct)
        getPixel(self.target, x, y, self.clr)

        self.clr.r = self.clr.r + self.quantificationError.r * pct
        self.clr.g = self.clr.g + self.quantificationError.g * pct
        self.clr.b = self.clr.b + self.quantificationError.b * pct

        setPixel(self.target, x, y, self.clr)
    end

    reportError(x+1, y  , self.pct7)
    reportError(x-1, y+1, self.pct3)
    reportError(x  , y+1, self.pct5)
    reportError(x+1, y+1, self.pct1)
end

Image.Filter.Hue = class() : extends(Image.Filter)

function Image.Filter.Hue:fragment(x, y)
    local clr = getPixel(self.source, x, y)

    self.target:set(x, y, Color.hsl(Color.rgb2hsl(clr), 0.5, 0.25))
end

Image.Filter.Grayscale = class() : extends(Image.Filter)

function Image.Filter.Grayscale:fragment(x, y, clr)
    return grayScale(clr)
end

Image.Filter.Edge = class() : extends(Image.Filter)

local function clr2vec(...)
    return vec3(...)
end

local function vec2clr(vec)
    return Color(vec.x, vec.y, vec.z)
end

function Image.Filter.Edge:fragment(x, y)
    local v = (
        clr2vec(getPixel(self.source, x-1, y+1))*(-1) +
        clr2vec(getPixel(self.source, x  , y+1))*( 0) + 
        clr2vec(getPixel(self.source, x+1, y+1))*( 1) + 
        clr2vec(getPixel(self.source, x-1, y  ))*(-1) +
        clr2vec(getPixel(self.source, x  , y  ))*( 0) + 
        clr2vec(getPixel(self.source, x+1, y  ))*( 1) + 
        clr2vec(getPixel(self.source, x-1, y-1))*(-1) +
        clr2vec(getPixel(self.source, x  , y-1))*( 0) + 
        clr2vec(getPixel(self.source, x+1, y-1))*( 1))

    self.target:set(x, y, vec2clr(v))
end

Image.Filter.Sort = class() : extends(Image.Filter)

function Image.Filter.Sort:init()
    Image.Filter.init(self)

    self.paletteByColor = Array()
    self.paletteByIndex = Array()
end

function Image.Filter.Sort:run(source, target)
    for y=1,source.height do
        for x=1,source.width do
            local clr = getPixel(source, x, y)
            local clrKey = tostring(clr)

            if self.paletteByColor[clrKey] == nil then
                self.paletteByColor[clrKey] = {
                    clr = clr,
                    clrKey = clrKey,
                    n = 0}
            end

            self.paletteByColor[clrKey].n = self.paletteByColor[clrKey].n + 1
        end
    end

    for k,v in pairs(self.paletteByColor) do
        self.paletteByIndex:add(v)
    end
    self.paletteByIndex:sort(
        function (a, b)
            local ha, sa, la = Color.rgb2hsl(a.clr)
            local hb, sb, lb = Color.rgb2hsl(b.clr)

            if round(ha) == round(hb) then
                if round(sa) == round(sb) then
                    return la < lb
                else
                    return sa < sb
                end
            else
                return ha < hb
            end
        end)

    Image.Filter.run(self, source, target)
end

function Image.Filter.Sort:fragment(x, y)
    local clrRef = self.paletteByIndex[1]

    self.target:set(x, y, Color.hsl(Color.rgb2hsl(clrRef.clr), 1, 0.5))

    clrRef.n = clrRef.n - 1
    if clrRef.n == 0 then
        self.paletteByIndex:remove(1)
    end
end

Image.Filter.Compose = class() : extends(Image.Filter)

function Image.Filter.Compose:init()
    self.filters = {
        Image.Filter.Grayscale,
        Image.Filter.Average
    }
end

function Image.Filter.Compose:run(source, target)
    for i,filter in ipairs(self.filters) do
        filter():run(source, target)
        source = target:copy()
    end
end

function setFilter(filter)
    filter():run(source, target)
--    env.thread = coroutine.create(
--        function ()
--            filter():run(source, target)
--        end)
end

function update(dt)
end

function draw()
    background(51)

    spriteMode(CORNER)

    if W > H then
        sprite(source, 0,   0, W/2, H)
        sprite(target, W/2, 0, W/2, H)
    else
        sprite(source, 0, 0,   W, H/2)
        sprite(target, 0, H/2, W, H/2)
    end
end
