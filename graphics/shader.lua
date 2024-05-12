Shader = class()

function Shader:init(name, path)
    return Shader.fromFile(name, path)
end

function Shader.fromFile(name, path)
    local self = Shader.new()
    path = path or 'resources'

    self.name = name
    self.pathName = path..'/'..self.name
    
    self.vertexShader = {pathFile = self.pathName..'.vertex.glsl'}
    self.pixelShader  = {pathFile = self.pathName..'.pixel.glsl'}

    self.loadCode = Shader.loadFromFile
    self:loadProgram()

    return self
end

function Shader.fromString(name, source)
    local self = Shader.new()
    self.name = name
    self.source = source
    
    self.vertexShader = {}
    self.pixelShader  = {source = source}

    self.loadCode = Shader.loadFromString
    self:loadProgram()

    return self
end

function Shader:loadProgram()
    if self:load() then
        self:compile()
    end
end

function Shader:load()
    if self:loadCode(self.vertexShader) then
        self:prepareCode(self.vertexShader)
    end

    if self:loadCode(self.pixelShader) then
        self:prepareCode(self.pixelShader)
        return true
    end
end

function Shader:loadFromFile(shader)
    if not shader.pathFile then return end

    local info = love.filesystem.getInfo(shader.pathFile)
    if not info then return false end

    local modtime = info.modtime
    if shader.modtime == nil or modtime > shader.modtime then
        shader.modtime = modtime
        shader.source = love.filesystem.read(shader.pathFile)
        return true
    end
end

function Shader:loadFromString(shader)
    if not shader.source then return end

    if shader.__source == nil or shader.__source ~= shader.source then
        shader.__source = shader.source
        return true
    end
end

function Shader:prepareCode(shader)
    local includes = {
        'graphics/shaders/maths.glsl',
        'graphics/shaders/colors.glsl',
        'graphics/shaders/noise2d.glsl',
        'graphics/shaders/noise3d.glsl',
    }

    shader.code = '#pragma language glsl3'..NL

    for _,include in ipairs(includes) do
        local code = love.filesystem.read(include)
        shader.code = shader.code..code..NL
    end

    shader.code = shader.code..
        '#line 1'..NL..
        shader.source

    return true
end

function Shader:compile()
    self.errorMsg = nil
    
    log('Compile shader : '..self.name)

    local status, result = xpcall(
        function ()
            return love.graphics.newShader(self.pixelShader.code, self.vertexShader.code)
        end,
        function (msg)
            log(msg)
            self.errorMsg = msg
        end)

    if status then
        self.program = result
    end
end

function Shader:update(dt)
    self:loadProgram()
end

function Shader:sendUniforms(uniforms, prefix)
    for k,v in pairs(uniforms) do
        local name = (prefix or '')..k
        if type(v) == 'table' and #v > 0 and type(v[1]) == 'table' then
            self:sendUniform(k..'Count', #v)
            if classnameof(v[1]):inList{'Color', 'vec2', 'vec3'} then
                local array = Array{}
                for i,o in ipairs(v) do
                    array:add{o:unpack()}
                end
                self:sendUniform(k, array:unpack())
            else    
                for i,o in ipairs(v) do
                    self:sendUniforms(o, k..'['..(i-1)..'].')
                end
            end

        elseif self.program:hasUniform(name) then        
            if type(v) == 'boolean' then
                self:sendUniform(name, v and 1 or 0)
            
            elseif classnameof(v):inList{'Color', 'vec2', 'vec3'} then
                self:sendUniform(name, {v:unpack()})

            else
                self:sendUniform(name, v)
            end
        end 
    end
end

function Shader:sendUniform(name, ...)
    if self.program:hasUniform(name) then
        self.program:send(name, ...)
    end
end

ShaderToy = class() : extends(Shader)

function ShaderToy:init(name, path)
    local self = ShaderToy.new()

    self.name = name
    self.pathName = path..'/'..self.name
    
    self.vertexShader = {}
    self.pixelShader  = {pathFile = self.pathName..'.glsl'}

    self:loadProgram()

    return self
end

function ShaderToy:loadCode(shader)
    local ok = Shader.loadFromFile(self, shader)
    if ok then
        local declarations = [[
            vec4 iResolution;
            //uniform vec3      iResolution;           // viewport resolution (in pixels)
            uniform float     iTime;                 // shader playback time (in seconds)
            uniform float     iTimeDelta;            // render time (in seconds)
            uniform float     iFrameRate;            // shader frame rate
            uniform int       iFrame;                // shader playback frame
            uniform float     iChannelTime[4];       // channel playback time (in seconds)
            uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
            uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
            uniform sampler2D iChannel0;             // input channel. XX = 2D/Cube
            uniform sampler2D iChannel1;             // input channel. XX = 2D/Cube
            uniform sampler2D iChannel2;             // input channel. XX = 2D/Cube
            uniform sampler2D iChannel3;             // input channel. XX = 2D/Cube
            uniform vec4      iDate;                 // (year, month, day, time in seconds)

            varying vec3 vPosition;
            varying vec2 vTexCoords;

            #define PI 3.14159265359
            
            #define love_texture Texel
            #define texture2D Texel
            #define precision
            #define highp
            
            #line 0
        ]]

        local mainFunction = [[
            vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
                iResolution = love_ScreenSize;
                
                vec4 fragColor;
                mainImage(fragColor, screen_coords);
                return fragColor;
            }
        ]]
        shader.source = declarations .. shader.source .. mainFunction

        return ok
    end
end
