local function hzFromKey(n)
    return 2^((n-49)/12) * 440
end

local function keyFromHz(hz)
    return floor(12 * math.log(hz/440, 2) + 49)
end

function App()
    return class() : extends(Sketch)
end

AppSound = App()

function AppSound:init()
    Sketch.init(self)

    audio = sound(SOUND_POWERUP)

    keyNumber = 49
    hz = hzFromKey(keyNumber)
    sampleRate = 44100
    amplitude = 50
    
    volume = 0.25
    love.audio.setVolume(volume)

    self.parameter:number('volume', 0, 1, 0.5,
        function ()
            love.audio.setVolume(volume)
            
            audio:stop()
            audio:play(true)
        end)
    self.parameter:action('play', function ()
            audio:play()
        end)
    self.parameter:action('mutate', function ()
            audio:mutate()
            audio:play()
        end)
    self.parameter:action('save', function ()
            audio:save('res/sounds/random')
        end)
    self.parameter:action('load', function ()
            audio:loadBufferFromSfxr('res/sounds/random')
        end)
    
    self.parameter:action('Pickup/Coin', function ()
            audio = sound(SOUND_PICKUP)
            audio:play()
        end)
    self.parameter:action('Laser/Shoot', function ()
            audio = sound(SOUND_SHOOT)
            audio:play()
        end)
    self.parameter:action('Explosion', function ()
            audio = sound(SOUND_EXPLODE)
            audio:play()
        end)
    self.parameter:action('Powerup', function ()
            audio = sound(SOUND_POWERUP)
            audio:play()
        end)
    self.parameter:action('Hit/Hurt', function ()
            audio = sound(SOUND_HIT)
            audio:play()
        end)
    self.parameter:action('Jump', function ()
            audio = sound(SOUND_JUMP)
            audio:play()
        end)
    self.parameter:action('Blip/Select', function ()
            audio = sound(SOUND_BLIT)
            audio:play()
        end)
    
    self.parameter:action('square', function ()
            audio = sound({
                    Waveform = SOUND_SQUAREWAVE
                })
        end)
    self.parameter:action('sinus', function ()
            audio = sound({
                    Waveform = SOUND_SINEWAVE
                })
        end)
    self.parameter:action('saw', function ()
            audio = sound({
                    Waveform = SOUND_SAWTOOTH
                })
        end)
    self.parameter:number('hz', 0, 4186, hz,
        function ()
            keyNumber = keyFromHz(hz)

            audio:stop()
            audio:loadBuffer(amplitude, hz, sampleRate)
            audio:play(true)
        end)
    self.parameter:integer('keyNumber', 1, 102, keyNumber,
        function ()
            hz = hzFromKey(keyNumber)
            
            audio:stop()
            audio:loadBuffer(amplitude, hz, sampleRate)
            audio:play(true)
        end)
    self.parameter:number('amplitude', 0, 100, 50,
        function ()
            audio:stop()
            audio:loadBuffer(amplitude, hz, sampleRate)
            audio:play(true)
        end)
end

function AppSound:draw()
    background()

    local sampleRate = audio:getSampleRate()
    local sampleCount = audio:getSampleCount()

    local vertices = Buffer('vec3')
    local verticesFin = Buffer('vec3')

    for i=0,sampleCount-1 do
        vertices:add(#vertices)
        vertices:add(audio:getSample(i)*100)
    end

    pushMatrix()
    do
        translate(0, H/2)

        noFill()
        polyline(vertices)
    end
    popMatrix()
end
