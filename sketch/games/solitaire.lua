Solitaire = class() : extends(Sketch)

function Solitaire:init()
    Sketch.init(self)

    Card.setup()

    self.deck = Deck(0, 0)
    self.deck.position:set(W-Card.wcard-Card.margin, Card.hcard)

    self.rows = Node()
    for i in range(7) do
        local deck = Deck(0, Card.wtext + Card.margin)
        self.rows:add(deck)
        deck.position:set((i-1)*Card.wcard+i*Card.margin/2, Card.hcard*2+Card.margin)
    end

    self.piles = Node()
    for i in range(4) do
        local deck = Deck(0, 0)
        self.piles:add(deck)
        deck.position:set((i-1)*Card.wcard+i*Card.margin/2, Card.hcard)
    end
    
    self.parameter:action('Nouvelle donne', function () self:newGame() end)

    self.scene = Scene()
    self.scene:add(self.rows)
    self.scene:add(self.piles)    
    self.scene:add(self.deck)
end

function Solitaire:resetGame()
    self.deck:reset()
    for i in range(7) do
        self.rows.items[i]:reset()
    end
end

function Solitaire:newGame()
    self:resetGame()

    self.deck:create()
    self.deck:shuffle()

    local index = 1
    local countCard = 0
    local nextStartIndex = 1

    while not (countCard == 28) do -- 7+6+5+4+3+2+1
        local card = self.deck.items:last()
        card:move2(self.rows.items[index], countCard)

        if index == #self.rows.items[index].items then
            card.visible = true
        end

        if index == 7 then -- #self.rows.items
            nextStartIndex = nextStartIndex + 1
            index = nextStartIndex
        else
            index = index + 1
        end
        countCard = countCard + 1        
    end
end

-- function Solitaire:mousepressed()
--     self:newGame()
-- end

function Solitaire:update(dt)    
end

function Solitaire:draw()
    background(colors.white)
    self.scene:draw()
end

Deck = class() : extends(Node)

function Deck:init(dx, dy)
    Node.init(self)
    
    self.dx = dx
    self.dy = dy

    self:reset()
end

function Deck:reset()
    self.items = Array()
end

-- coeur / heart
-- carreau / diamond
-- trefle / club
-- pique / spade

function Deck:create()
    for _,clr in ipairs{'coeur', 'carreau', 'trefle', 'pique'} do
        for value in range(13) do
            self:push(Card(clr, value, false))
        end
    end
end

function Deck:shuffle()
    local items = self.items
    self.items = Array()
    for _ in range(#items) do
        local i = randomInt(1, #items)
        self:push(items:remove(i))
    end
end

function Deck:push(card, count)
    count = count or 0

    -- compute next position
    if card.position == vec2() then
        card.position:set(self.position)
    end

    card.nextPosition = vec2()
    if #self.items == 0 then
        card.nextPosition:set(self.position.x, self.position.y)
    else
        local lastCard = self.items[#self.items]
        card.nextPosition:set(
            lastCard.nextPosition.x + self.dx,
            lastCard.nextPosition.y + self.dy)
    end

    -- init animation
    animate(card.position, card.nextPosition, {
        delayBeforeStart = count/60,
        delay = 30/60
    }, tween.easing.quadOut)

    self.items:push(card)
    card.deck = self
end

function Deck:draw()
    noFill()
    stroke(colors.gray)
    strokeSize(1)
    rect(self.position.x, self.position.y, Card.wcard, Card.hcard, Card.margin)

    for _,card in ipairs(self.items) do
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
    Rect.init(self, 0, 0, Card.wcard, Card.hcard)

    self.clr = clr
    self.value = value
    self.visible = visible
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

function Card:click()
    -- find first available move
    local sketch = env.sketch
    self:move2(sketch.piles.items[1])
end

function Card:move2(newDeck, countCard)
    self.deck.items:pop()
    newDeck:push(self, countCard)
end
