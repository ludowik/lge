local defaultPalette = Array{
    colors.white,
    colors.black,
}

function setup()
    source = image('seychelles.png')
    img = source:copy()

    parameter:watch('palette', 'palette:count()', function ()
        palette:pop()
        needUpdate = true
    end)

    parameter:action('reset palette', function ()
--        palette = defaultPalette:clone()
        palette = computePalette():clone()
        setSetting('palette', palette)
        needUpdate = true
    end)

    parameter:integer('ral', 0, 256, 32, function ()
        needUpdate = true
    end).incrementValue = 32

    parameter:integer('radius', 1, 32, getSetting('radius', 3), function ()
        setSetting('radius', radius)
        needUpdate = true
    end)

    parameter:boolean('weighted', getSetting('weighted', false), function ()
        setSetting('weighted', weighted)
        needUpdate = true
    end)

    needUpdate = true
end

function resume()
    if not isFullScreen() then
        toggleFullScreen(true)
    end

    needUpdate = true
end

function adjustColor(clr)
    -- local h, s, l = clr:rgb2hsl()
    -- return Color.hsl(h, s, adjustComponent(l))
    local r = adjustComponent(clr.r)
    local g = adjustComponent(clr.g)
    local b = adjustComponent(clr.b)

    return Color(r, g, b, clr.a)
end

function adjustComponent(clr)
    if ral == 0 then return clr end
    return round(clr*256.0/ral) * ral / 256.0
end

function computePalette()
    local colorsRef = Array()
    for x=0, source.width-1 do
        for y=0, source.height-1 do
            local clr = Color(source:getPixel(x, y))
            clr = adjustColor(clr)

            local ref = tostring(clr)
            if colorsRef[ref] == nil then
                colorsRef[ref] = {
                    count = 0,
                    clr = clr,
                }
            end

            colorsRef[ref].count = colorsRef[ref].count + 1
        end
    end

    local colors = Array()
    for k,clr in pairs(colorsRef) do
        colors:add(clr)
    end

    colors:sort(function (a, b)
        return a.clr.g < b.clr.g
        -- if a.count == b.count then
        --     return a.clr < b.clr
        -- end
        -- return a.count > b.count
    end)

    local palette = Array()
    for i=1,16 do
        palette:add(colors[i].clr)
        print(colors[i].clr, colors[i].count)
    end

    return palette
end

function resume()
    if not isFullScreen() then
        toggleFullScreen(true)
    end

    palette = Array(getSetting('palette', defaultPalette:clone()))
end

function initShader()
    if shader then shader:release() end
    
    shader = Shader.fromString('transform', [[
        uniform highp float ral;
        uniform highp float radius;
        uniform highp float weighted;

        uniform highp int paletteCount;
        uniform highp vec4 palette[32];

        float adjustComponent(float clr) {
            if (ral == 0.0) return clr;
            return round(clr*256.0/ral) * ral / 256.0;
        }

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            float step_x = 1.0/love_ScreenSize.x;
            float step_y = 1.0/love_ScreenSize.x;
            float n = radius;
            float dx = n*step_x;
            float dy = n*step_y;
            float count = 0.;
            float rt = 0.0;
            float gt = 0.0;
            float bt = 0.0;
            float size = length(vec2(dx, dy));
            for (float x=-dx; x<dx; x+=step_x) {
                for (float y=-dy; y<dy; y+=step_y) {
                    vec2 offset = vec2(x, y);
                    float weight = weighted == 1. ? size-length(offset) : 1.0;
                    count += weight;
                    vec4 pixel = Texel(texture, texture_coords + offset);
                    float r = adjustComponent(pixel.r);
                    float g = adjustComponent(pixel.g);
                    float b = adjustComponent(pixel.b);
                    rt += r * weight;
                    gt += g * weight;
                    bt += b * weight;
                }
            }

            float r = rt / count;
            float g = gt / count;
            float b = bt / count;

            float minDistance = 10000.0;
            vec4 ref = vec4(0.0);

            for (int i=0; i<paletteCount; i++) {
                float distance = distance(palette[i].rgb, vec3(r, g, b));
                if (distance <= minDistance) {
                    minDistance = distance;
                    ref = palette[i];
                }
            }

            float minvalue = 0.15;
            float maxvalue = 0.85;
            return vec4(
                clamp(ref.r, minvalue, maxvalue),
                clamp(ref.g, minvalue, maxvalue),
                clamp(ref.b, minvalue, maxvalue),
                1.0);
        }
    ]])

    shader:sendUniforms({
        ral = ral,
        radius = radius,
        weighted = weighted and 1 or 0,
        palette = palette,
    })

    setShader(shader.program)
end

function update()
    if not needUpdate then return end
    needUpdate = false

    img:render(function ()
        background()
        initShader()
        spriteMode(CORNER)
        sprite(source)
    end)
end

function draw()
    background(backgroundColor)

    local scaleFactor = W/2/img.width
    scale(scaleFactor)

    spriteMode(CENTER)
    sprite(img, img.width/2, CY/scaleFactor)

    setShader()
    sprite(source, img.width*3/2, CY/scaleFactor)
end

function getPosition(mouse)
    local scaleFactor = W/2/img.width

    local x = (mouse.position.x/scaleFactor) % img.width
    local y = (mouse.position.y/scaleFactor) - (CY/scaleFactor-img.height/2)

    x = clamp(x, 0, img.width-1)
    y = clamp(y, 0, img.height-1)

    return x*dpiscale, y*dpiscale
end

function mousepressed(mouse)
    local x, y = getPosition(mouse)
    local clr = Color(source:getPixel(x, y))
    palette:add(clr)
    setSetting('palette', palette)
    needUpdate = true
end

function __mousemoved(mouse)
    local x, y = getPosition(mouse)
    backgroundColor = Color(source:getPixel(x, y))
end
