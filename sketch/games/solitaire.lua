Solitaire = class() : extends(Sketch)

function Solitaire:init()
    Sketch.init(self)
    Card.setup()

    self.deck = Deck()
    self.deck.position:set(60, 10)
    self.deck:create()
    self.deck:shuffle()

    self.pile = Deck()
    self.pile.position:set(120, 10)
    
    self.parameter:watch('Cards', '#sketch.deck.cards')

    self.scene = Scene()
    self.scene:add(self.deck)
    self.scene:add(self.pile)
end

function Solitaire:mousepressed()
    self.move = not self.move
end

function Solitaire:update(dt)
    if self.move and #self.deck.cards > 0 then
        self.pile:push(self.deck.cards:pop())
    end
end

function Solitaire:draw()
    background(colors.white)
    self.scene:draw()
end

Deck = class() : extends(Rect)

-- coeur / heart
-- carreau / diamond
-- pique / spade
-- trefle / club

function Deck:init(nb)
    Rect.init(self)
    self.cards = Array()
end

function Deck:create()
    for _,clr in ipairs{'coeur', 'carreau', 'trefle', 'pique'} do
        for value in range(13) do
            self:push(Card(clr, value, true))
        end
    end
end

function Deck:shuffle()
    local cards = self.cards
    self.cards = Array()
    for _ in range(#cards) do
        local i = randomInt(1, #cards)
        self:push(cards:remove(i))
    end
end

function Deck:push(card)
    card.nextPosition = vec2()
    if #self.cards == 0 then
        card.nextPosition:set(self.position.x, self.position.y)
    else
        local lastCard = self.cards[#self.cards]
        card.nextPosition:set(lastCard.nextPosition.x, lastCard.nextPosition.y + Card.wtext + Card.margin)
    end

    animate(card.position, card.nextPosition, 1, tween.easing.quadOut)

    self.cards:push(card)
end

function Deck:draw()
    noFill()
    stroke(colors.gray)
    strokeSize(1)
    rect(self.position.x, self.position.y, Card.wcard, Card.hcard, Card.margin)

    for _,card in ipairs(self.cards) do
        card:draw()
    end
end

Card = class() : extends(Rect)

function Card.setup()
    Card.size = Anchor(7):size(1, 1):floor()
    Card.size.y = floor(Card.size.x * 1.5)

    Card.margin = 4

    Card.wcard = floor(Card.size.x * 0.95)
    Card.hcard = floor(Card.size.y * 0.95)

    Card.wtext = floor(Card.wcard * 0.4)
end

function Card:init(clr, value, visible)
    Rect.init(self)

    self.clr = clr
    self.value = value
    self.visible = visible or false
    self.img = Image('resources/images/'..clr..'.png')
end

local labels = {'A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'}
function Card:draw()
    local x, y = self.position.x, self.position.y

    local size = Card.size
    local margin = Card.margin
    local wcard = Card.wcard
    local hcard = Card.hcard
    local wtext = Card.wtext
    
    if self.visible then
        strokeSize(0.5)
        stroke(colors.black)
        fill(colors.white)
        rectMode(CORNER)
        rect(x, y, wcard, hcard, Card.margin)

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
        strokeSize(0.5)
        stroke(colors.black)
        fill(colors.blue)
        rectMode(CORNER)
        rect(x, y, wcard, hcard, Card.margin)
    end
end
