Solitaire = class() : extends(Sketch)

function Solitaire:init()
    Sketch.init(self)
    self.deck = Deck()
    self.deck:shuffle()

    self.parameter:watch('Cards', '#sketch.deck.cards')

    self.anchor = Anchor(7)
end

function Solitaire:update(dt)
end

function Solitaire:draw()
    background(colors.white)
    self.deck:draw()
end

Deck = class()

-- coeur / heart
-- carreau / diamond
-- pique / spade
-- trefle / club

function Deck:init(nb)
    self.cards = Array()
    for _,clr in ipairs{'coeur', 'carreau', 'trefle', 'pique'} do
        for value in range(13) do
            self.cards:push(Card(clr, value, true))
        end
    end
end

function Deck:shuffle()
    local cards = Array()
    for _ in range(#self.cards) do
        local i = randomInt(1, #self.cards)
        cards:push(self.cards:remove(i))
    end
    self.cards = cards
end

function Deck:draw()
    local x, y  = 0, 0
    for _,card in ipairs(self.cards) do
        local w, h = card:draw(x, y)
        x = x + w
        if x > W - w then
            x = 0
            y = y + h
        end
    end
end

Card = class()

function Card:init(clr, value, visible)
    self.clr = clr
    self.value = value
    self.visible = visible or false
    self.img = Image('resources/images/'..clr..'.png')
end

local labels = {'A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'}
function Card:draw(x, y)
    local size = sketch.anchor:size(1, 1)
    size.y = size.x * 1.5

    local margin = 3

    local wcard = size.x * 0.95
    local hcard = size.y * 0.95
    
    if self.visible then
        local wtext = wcard * 0.4

        strokeSize(0.5)
        stroke(colors.black)
        fill(colors.white)
        rectMode(CORNER)
        rect(x, y, wcard, hcard, 4)

        fontSize(wtext)
        fontName('arial')
        textMode(CENTER)
        textColor(colors.black)
        text(labels[self.value],
            x + wtext/2 + margin,
            y + wtext/2 + margin)

        spriteMode(CENTER)
        sprite(self.img,
            x + wcard - wtext/2 - margin,
            y + wtext/2 + margin, wtext, wtext)

        sprite(self.img,
            x + wcard/2,
            y + hcard - wcard/2 - margin, wcard*.7, wcard*.7)
    else
        text('dos', x, y)
    end
    return size.x, size.y
end
