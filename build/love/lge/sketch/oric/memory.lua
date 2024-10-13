Memory = class()

function Memory:init()
    self.ram = {}
    self.rom = {}
end

function Memory:read(address)
    assert(address < 0xFFFF)
    if address < 0xC000 then
        return self.ram[address]
    else
        return self.rom[address]
    end
end

function Memory:write(address, value)
    assert(address < 0xFFFF)
    if address < 0xC000 then
        self.ram[address] = value
    end
end

