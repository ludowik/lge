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
            return math.floor(W), math.floor(H), {fullscreen = false}
        end,

        setTitle = function (title)
            js.global.title = title
        end,

        getDesktopDimensions = function ()
            return math.floor(W), math.floor(H)
        end,

        getSafeArea = function ()
            return math.floor(LEFT), math.floor(TOP), math.floor(W), math.floor(H)
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
        getCanvas = function ()
            return {
                getWidth = function ()
                    return W
                end,
                getHeight = function ()
                    return H
                end,
            }
        end,

        setCanvas = function ()    
        end,

        reset = function ()
        end,

        clear = function ()
        end,

        origin = function ()
        end,

        translate = function ()
        end,

        scale = function ()
        end,

        draw = function ()
        end,

        text = function ()
        end,

        present = function ()
        end,

        setWireframe = function ()
        end,

        setShader = function ()
        end,
        
        setDepthMode = function ()
        end,

        setColor = function ()
        end,

        setBlendMode = function ()            
        end,

        newFont = function ()
        end,

        inverseTransformPoint = function (...)
            return ...
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
