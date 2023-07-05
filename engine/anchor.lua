Anchor = class()

function Anchor:init(ni, nj)
    self.ni = ni or 10
    self.nj = nj or math.ceil(H/(W/self.ni))

    self.clr = Color(1, 1, 1, 0.25)
end

function Anchor:pos(i, j)
    return vec2((i)*(W/self.ni), (j)*(H/self.nj))
end

function Anchor:size(i, j)
    return vec2(i*(W/self.ni), j*(H/self.nj))
end

function Anchor:draw(clr)
    stroke(clr or self.clr)
    strokeSize(0.5)

    for i in index(self.ni) do
        for j in index(self.nj) do
        
            line(
                self:pos(i, j).x,
                self:pos(1, j).y,
                self:pos(i, j).x + self:size(1, 1).x,
                self:pos(1, j).y)

            line(
                self:pos(i, j).x + self:size(1, 1).x,
                self:pos(1, j).y,
                self:pos(i, j).x + self:size(1, 1).x,
                self:pos(1, j).y + self:size(1, 1).y)
        end
    end
end
