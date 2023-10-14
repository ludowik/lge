local sfxr = require 'lib.sfxr'

Sound = class ()

function Sound.setup()
    AMPLITUDE_MAX = 100

    SOUND_PICKUP = 'SOUND_PICKUP'
    SOUND_SHOOT = 'SOUND_SHOOT'
    SOUND_EXPLODE = 'SOUND_EXPLODE'
    SOUND_POWERUP = 'SOUND_POWERUP'
    SOUND_HIT = 'SOUND_HIT'
    SOUND_JUMP = 'SOUND_JUMP'
    SOUND_BLIT = 'SOUND_BLIT'

    Sound.sounds = {
        SOUND_PICKUP = sfxr.randomPickup,
        SOUND_SHOOT = sfxr.randomLaser,
        SOUND_EXPLODE = sfxr.randomExplode,
        SOUND_POWERUP = sfxr.randomPowerup,
        SOUND_HIT = sfxr.randomHit,
        SOUND_JUMP = sfxr.randomJump,
        SOUND_BLIT = sfxr.randomBlit,
    }
end

function Sound:init(id)
    if id then
        self:loadFromId(id)
    end
end

function Sound:getSampleRate()
    return self.sounddata:getSampleRate()
end

function Sound:getSampleCount()
    return self.sounddata:getSampleCount()
end

function Sound:getSample(i)
    return self.sounddata:getSample(i)
end

function Sound:loadBuffer(amplitude, hz, sampleRate)
    local n = sampleRate
    local da = TAU/n
    self.sounddata = love.sound.newSoundData(n, 44100, 16, 1)
    for i = 0, n - 1 do
        self.sounddata:setSample(i, sin(i/(44100/hz)*TAU)*amplitude/AMPLITUDE_MAX)
    end
end

function Sound:loadFromId(id)
    self.sound = self.sound or sfxr.newSound()
    self.id = id

    if Sound.sounds[id] then
        Sound.sounds[id](self.sound(os.time()))
    else
        self.sound:randomize(os.time())
    end

    local tab = self.sound:generateTable(sfxr.FREQ_44100, sfxr.BITS_FLOAT)
    self.sounddata = love.sound.newSoundData(#tab, 44100, 16, 1)
    for i = 0, #tab - 1 do
        local v = tab[i + 1]
        -- Copy the sample over to the SoundData
        self.sounddata:setSample(i, v)
    end
end

function Sound:play()
    self.source = love.audio.newSource(self.sounddata)
    self.source:play()
end

function Sound:stop()
    if self.source then
        self.source:stop()
    end
end

function Sound:mutate()
    if self.sound then
        self.sound:mutate()
    end
end

function sound(id)
    return Sound(id)
end

function soundBufferSize()
    return 0, 0
end
