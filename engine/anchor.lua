Anchor = class()

function Anchor:init(ni, nj)
    self.ni = ni or 10
    self.nj = nj or math.ceil(H/(W/self.ni))

    self.clr = Color(1, 1, 1, 0.25)
end

function Anchor:pos(i, j)
    if i < 0 then i = self.ni + i end
    if j < 0 then j = self.nj + j end
    return vec2((i)*(W/self.ni), (j)*(H/self.nj))
end

function Anchor:size(i, j)
    return vec2(i*(W/self.ni), j*(H/self.nj))
end

function Anchor:draw(clr)
    stroke(clr or self.clr)
    strokeSize(0.5)

    for j in index(self.nj+1) do
        line(
            self:pos(0, j).x,
            self:pos(0, j).y,
            self:pos(0, j).x + self:size(self.ni, 0).x,
            self:pos(0, j).y)
    end

    for i in index(self.ni+1) do
        line(
            self:pos(i, 0).x,
            self:pos(i, 0).y,
            self:pos(i, 0).x,
            self:pos(i, 0).y + self:size(0, self.nj).y)
    end
end
