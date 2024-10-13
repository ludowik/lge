CPU = class()

function CPU:init()
    self.A = 0 -- accumulator
    self.X = 0 -- x register
    self.Y = 0 -- y register
    self.SP = 0xFF -- stact pointer
    self.PC = 0x0000 -- program counter
    self.status = 0x00 -- status register
    self.memory = Memory()
end
