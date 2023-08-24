Tree = class() : extends(Sketch)

function Tree:init()
    Sketch.init(self)

    originMode(BOTTOM_LEFT)

    self.parameter:number('lenBranch', 'lenBranch', 100, 500, 120)
    self.parameter:integer('levelBranch', 'levelBranch', 0, 10, 6)
    self.parameter:number('angleBranch', 'angleBranch', 0, 90, 45)
    self.parameter:number('ratioBranch', 'ratioBranch', 0.2, 0.8, 0.63)
end

function Tree:draw()
    background(51)

    b = Branch(W/2, 150, lenBranch, 0)
    b:draw()
end

Branch = class('Branch')

function Branch:init(x, y, len, angle, level)
    level = (level or 0) + 1

    self.x = x
    self.y = y

    self.len = len

    self.angle = angle

    if level < levelBranch then
        self.branchA = Branch(0, len, len*ratioBranch,  angleBranch, level)
        self.branchB = Branch(0, len, len*ratioBranch, -angleBranch, level)
    end
end

function Branch:draw()
    pushMatrix()

    stroke(colors.white)

    translate(self.x, self.y)
    rotate(self.angle)

    line(0, 0, 0, self.len)

    if self.branchA then
        self.branchA:draw()
        self.branchB:draw()
    end

    popMatrix()
end
