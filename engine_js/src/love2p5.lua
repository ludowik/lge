pg, cc = js.global, {pg = js.global}

arg = {
}

io = {
    stdout = {
        setvbuf = function ()
        end
    }
}

love = {
    getVersion = function ()
        return 0, 9, 0, 'p5'
    end,

    system = {
        getOS = function ()
            return 'web'
        end,

        getPowerInfo = function ()
            return 'unknown', 0, 0
        end,
    },

    math = math,

    window = {
        setMode = function ()
        end,
        
        getMode = function ()
            return
                js.global.screen.width,
                js.global.screen.height,
                {
                    fullscreen = false
                }
        end,

        setTitle = function (title)
            js.global.title = title
        end,

        getDesktopDimensions = function ()
            return
                js.global.screen.width,
                js.global.screen.height
        end,

        getSafeArea = function ()
            return
                0, 0,
                js.global.screen.width,
                js.global.screen.height
        end,

        getDPIScale = function ()
            return 1
        end,

        setVSync = function ()
        end,

        getDisplayCount = function ()
            return 0
        end
    },
    
    graphics = {
        newCanvas = function (w, h)
            local frameBuffer = js.global:createGraphics(w, h)
            frameBuffer:angleMode(js.global.RADIANS)
            frameBuffer:colorMode(js.global.RGB, 1)
            frameBuffer:textAlign(js.global.LEFT, js.global.TOP)
            
            return {
                pg = frameBuffer,

                width = w,
                height = h,
                
                getWidth = function (self)
                    return self.width
                end,
                
                getHeight = function (self)
                    return self.height
                end,
                
                newImageData = function (self)
                    self.pg:loadPixels()
                    
                    return {
                        pg = self.pg,
                        pixels = self.pg.pixels,
                        
                        width = self.width,
                        height = self.height,

                        getWidth = function (self)
                            return self.width
                        end,
                        
                        getHeight = function (self)
                            return self.height
                        end,
                        
                        setPixel = function (self, x, y, r, g, b, a)
                            self.pg:set(x, y, 255*r, 255*g, 255*b, 255*a)
                        end,

                        getPixel = function (self, x, y)
                            return self.pg:get(x, y)
                        end,

                        mapPixel = function (self, f)
                            local index = 0
                            for x=0,self.width-1 do
                                for y=0,self.height-1 do
                                    self.pixels[index],
                                    self.pixels[index+1],
                                    self.pixels[index+2],
                                    self.pixels[index+3] = f(x, y, 
                                        self.pixels[index],
                                        self.pixels[index+1],
                                        self.pixels[index+2],
                                        self.pixels[index+3])
                                    index = index + 4
                                end
                            end
                        end,

                        encode = function ()
                        end,

                        release = function ()
                        end,
                    }
                end,

                draw = function (self, x, y, rotation, sx, sy)
                    pg:blendMode(NORMAL)
                    sx = sx or 1
                    sy = sy or 1
                    js.global:image(self.pg, x, y, w*sx, h*sy, 0, 0, w, h)
                end,

                release = function ()
                end,
            }
        end,

        setCanvas = function (canvas)
            if canvas then
                cc = canvas[1]
                if cc.pg and cc.pg['begin'] then
                    cc.pg['begin'](cc.pg)
                    cc.pg:background(51)
                    cc.pg:rect(1, 1, 155, 55)
                end
            else
                if cc.pg and cc.pg['end'] then
                    cc.pg['end'](cc.pg)
                end
                cc = {pg = js.global}
            end
            pg = cc.pg
        end,
        
        getCanvas = function ()
            return cc
        end,

        newImage = function (path_imageData)
            local img

            if type(path_imageData) == 'string' then
                img = js.global:loadImage(path_imageData)
            else
                img = path_imageData.pg
            end

            return {
                img = img,

                getFormat = function (self)
                    return 0
                end,
                
                getDimensions = function (self)
                    return self.img.width, self.img.height
                end,
                
                getWidth = function (self)
                    return self.img.width
                end,
                
                getHeight = function (self)
                    return self.img.height
                end,
                
                draw = function (self, x, y, rotation, sx, sy)
                    pg:blendMode(NORMAL)
                    sx = sx or 1
                    sy = sy or 1
                    w = self.img.width
                    h = self.img.height
                    pg:image(self.img, x, y, w*sx, h*sy, 0, 0, w, h)
                end,
                
                replacePixels = function (pixels)
                    pg.pixels = pixels
                    pg:updatePixels()
                end,
                
                release = function ()
                end,

                setFilter = function ()
                end,
            }
        end,

        reset = function ()
            -- reset syles
            resetStyles()
        end,

        clear = function (...)
            local args = {...}
            if #args == 7 then
                pg:clear(args[1], args[2], args[3], args[4])
            else
                pg:clear(0, 0, 0, 1)
            end
        end,

        origin = function ()
            pg:resetMatrix()
        end,

        translate = function (...)
            pg:translate(...)
        end,

        scale = function (...)
            pg:scale(...)
        end,

        draw = function (img, x, y, angle, sx, sy)
            img:draw(
                x or 0,
                y or 0,
                angle or 0,
                sx or 1,
                sy or 1)
        end,

        present = function ()
        end,

        setWireframe = function ()
        end,

        setShader = function ()
        end,
        
        setDepthMode = function ()
        end,

        setColor = function (...)
            pg:stroke(...)
            pg:fill(...)
        end,

        setBlendMode = function (mode)
            pg:blendMode(mode)
        end,

        inverseTransformPoint = function (...)
            return ...
        end,

        setPointSize = function (...)
            pg:strokeWeight(...)
        end,

        setLineWidth = function (...)
            pg:strokeWeight(...)
        end,

        point = function (...)
            pg:point(...)
        end,

        points = function (vertices, ...)
            if type(vertices) == 'number' then points{vertices, ...} end
            
            if type(vertices[1]) == 'number' then
                for i=1,#vertices,2 do
                    pg:point(vertices[i], vertices[i+1])
                end
            else
                for i,v in ipairs(vertices) do
                    pg:stroke(v[3], v[4], v[5], v[6])
                    pg:point(v[1], v[2])
                end
            end
        end,

        line = function (...)
            pg:line(...)
        end,

        rectangle = function (mode, ...)
            if mode == 'line' then
                pg:noFill()
            else
                pg:noStroke()
            end

            pg:rect(...)
        end,

        circle = function (mode, x, y, radius)
            if mode == 'line' then
                pg:noFill()
            else
                pg:noStroke()
            end

            pg:circle(x, y, radius)
        end,

        ellipse = function (mode, x, y, r1, r2)
            if mode == 'line' then
                pg:noFill()
            else
                pg:noStroke()
            end

            pg:ellipse(x, y, r1*2, r2*2)
        end,

        arc = function (mode, _, x, y, radius, a1, a2, segments)
            if mode == 'line' then
                pg:noFill()
            else
                pg:noStroke()
            end
            pg:arc(x, y, 2*radius, 2*radius, a1, a2)
        end,

        polygon = function (vertices)
            pg:beginShape(js.global.LINES)
            for i=1,#vertices,2 do
                pg:vertex(vertices[i], vertices[i+1])
            end
            pg:endShape(js.global.CLOSE)
        end,

        newFont = function (fontName, fontSize)
            fontSize = fontSize or fontName or DEFAULT_FONT_SIZE
            return {
                fontSize = fontSize,

                getWidth = function (self, str)
                    pg:textSize(fontSize)
                    return pg:textWidth(str)
                end,
                
                getHeight = function ()
                    pg:textSize(fontSize)
                    return pg:textAscent(str) + pg:textDescent('A')
                end,
            }            
        end,

        setFont = function (font)
            pg:textSize(font.fontSize)
        end,

        textSize = function (...)
            return
                pg:textWidth(...),
                pg:textAscent(...) + pg:textDescent(...)
        end,

        text = function (str, x, y)
            pg:noStroke()
            pg:text(str, x, y)
        end,
    },

    keyboard = {
        setKeyRepeat = function ()
        end,
    },
    
    filesystem = {
        getInfo = function ()
            return {
                modtime = 0
            }
        end,

        getRequirePath = function ()
            return package.path
        end,

        getDirectoryItems = function ()
            return {}    
        end,

        getSaveDirectory = function ()
            return ''
        end,

        createDirectory = function ()
        end,

        write = function (fileName, data)
            js.global.localStorage:setItem(fileName, data)
        end,

        read = function (filename)
            local data = js.global.localStorage:getItem(filename)
            return data
        end,

        load = function (filename)
            local data = love.filesystem.read(filename)
            return loadstring(data)
        end
    },

    mouse = {
        isDown = function ()
            return js.global.mouseIsPressed
        end,

        setPosition = function ()
        end,
    },

    keyboard ={
        isDown = function (key)
            return __isKeyDown(key)
        end,

        setKeyRepeat = function ()
        end,

        setTextInput = function (activate)

        end
    },

    timer = {
        getTime = function ()
            return js.global.Date:now() / 1000.
        end,

        getFPS = function ()
            return js.global:getTargetFrameRate()
        end,
    },
    
    touch = {
        getTouches = function ()
            return js.global.touches
        end
    },

    audio = {
        newSource = function ()
            return {}
        end,

        setVolume = function ()
        end,
    },

    event = {
        quit = function (mode)
            js.global.location:reload()
        end
    }
}
