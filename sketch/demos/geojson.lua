function setup()    
    local str = love.filesystem.read('resources/uga.geojson')
    map = json.decode(str)

    minx = math.maxinteger
    miny = math.maxinteger

    maxx = -math.maxinteger
    maxy = -math.maxinteger

    ugas = Array()
    for i,feature in ipairs(map.features) do
        beginShape()
        for _,v in ipairs(feature.geometry.coordinates[1][1]) do
            local lon = v[1]
            local lat = v[2]
            
            x, y = latLonToOffsets(lat, lon, CX, CX)
            
            minx = min(minx, x)
            miny = min(miny, y)

            maxx = max(maxx, x)
            maxy = max(maxy, y)
            
            vertex(x, y)
        end
        local shape = endShape(CLOSE)

        ugas:add(shape)
    end
    
    scalex = (maxx - minx)
    scaley = (maxy - miny)
    
    position = vec2()

    zoom = 1
end

function draw()
    background()

    translate(CX, CY)
    
    scale(zoom)
    
    translate(position.x, position.y)
    
    scale(W/scalex, W/scalex)
    translate(-minx-scalex/2, -miny-scaley/2)
    
    strokeSize(scalex/W/zoom)
    
    noFill()
    
    ugas:draw()
end

function mousemoved(touch)
    position:add(vec2(touch.deltaPos.x, touch.deltaPos.y))
end

function latLonToOffsets(latitude, longitude, mapWidth, mapHeight)
    local FE = 180 -- false easting
    local radius = mapWidth / (2 * PI)

    local latRad = rad(latitude)
    local lonRad = rad(longitude + FE)

    local x = lonRad * radius

    local yFromEquator = radius * math.log(math.tan(PI / 4 + latRad / 2))
    local y = mapHeight / 2 - yFromEquator

    return x, y
end
