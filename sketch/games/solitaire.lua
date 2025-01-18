Solitaire = class() : extends(Sketch)

-- TODO : Trouver d'autres icônes sans fioritures sur les couleurs
-- TODO : Gestion de l'historique aussi sur le tas ?

function Solitaire:init()
    Sketch.init(self)

    self:initScene()
    self:initPosition()
    
    self:loadGame()

    self:initParameters()
end

function Solitaire:resize()
    self:saveGame()
    self:initPosition()
    self:loadGame()
end

function Solitaire:initScene()
    self.deckList = Array()

    self.deck = Deck(0, 0)
    self.deckList:push(self.deck)

    self.wast = Wast(Card.wcard / 3, 0)
    self.deckList:push(self.wast)

    self.piles = Node()
    for i in range(4) do
        local deck = Pile(0, 0)
        self.deckList:push(deck)
        self.piles:add(deck)
    end

    self.rows = Node()
    for i in range(7) do
        local deck = Row(0, Card.wtext + Card.margin)
        self.deckList:push(deck)
        self.rows:add(deck)
    end
    
    self.scene = Scene()
    self.scene:add(self.rows)
    self.scene:add(self.piles)
    self.scene:add(self.wast)
    self.scene:add(self.deck)

    self.score = 0
end

function Solitaire:initPosition()
    local ny = 3

    Card.initSize()

    local estimateW = 7 * Card.wcard + 8 * Card.margin
    local estimateH = 2 * Card.wcard + 2 * Card.margin + 10 * (Card.wtext + Card.margin)

    local x, y    
    x = (W - estimateW) / 2
    y = (H - estimateH) / 2

    self.wast:changePosition(vec2(x + 4 * Card.wcard + 6 * Card.margin, y))
    self.deck:changePosition(vec2(x + 6 * Card.wcard + 7 * Card.margin, y))

    for i in range(self.piles:count()) do
        self.piles.items[i]:changePosition(vec2(x + (i - 1) * Card.wcard + i * Card.margin, y))
    end

    for i in range(self.rows:count()) do
        self.rows.items[i]:changePosition(vec2(x + (i - 1) * Card.wcard + i * Card.margin, y + Card.hcard + 2 * Card.margin))
    end
end

function Solitaire:initParameters()
    self.parameter:boolean('Auto', Bind(self, 'autoPlay'), true)
    self.parameter:boolean('3 cartes', Bind(self, 'play3Card'), getAppSetting('play3Card', true),
        function ()
            setAppSetting('play3Card', self.play3Card)
        end)
    self.parameter:watch('Score', Bind(self, 'score'))        
    self.parameter:action('Nouvelle donne', function() self:newGame() end)
    self.parameter:action('Rejouer', function() self:newGame(self.seedValue) end)

    self.parameter:action(Bind('"Annuler " .. #sketch.movesBack'), function ()
        self:undo()
    end)
end

function Solitaire:resetGame()
    self.deck:reset()
    self.wast:reset()

    for i in range(self.piles:count()) do
        self.piles.items[i]:reset()
    end
    for i in range(self.rows:count()) do
        self.rows.items[i]:reset()
    end

    self:resetHistory()
end

function Solitaire:newGame(seedValue)
    self:resetGame()

    self.deck:create()
    self.deck:shuffle(seedValue)

    local index = 1
    local countCard = 0
    local nextStartIndex = 1

    while not (countCard == 28) do -- 7+6+5+4+3+2+1
        local card = self.deck.items:last()
        card:moveTo(self.rows.items[index], countCard)

        if index == #self.rows.items[index].items then
            card.faceUp = true
        end

        if index == 7 then
            nextStartIndex = nextStartIndex + 1
            index = nextStartIndex
        else
            index = index + 1
        end
        countCard = countCard + 1
    end

    self:resetHistory()
    self:saveGame()
end

function Solitaire:nextSeedValue()
    return randomInt(2^16)
end

function Solitaire:saveGame()
    saveData('solitaire', self:serialize())
end

function Solitaire:serialize()
    return {
        seedValue = self.seedValue,
        score = self.score,
        deck = self.deck:serialize(),
        wast = self.wast:serialize(),
        rows = {
            self.rows.items[1]:serialize(),
            self.rows.items[2]:serialize(),
            self.rows.items[3]:serialize(),
            self.rows.items[4]:serialize(),
            self.rows.items[5]:serialize(),
            self.rows.items[6]:serialize(),
            self.rows.items[7]:serialize(),
        },
        piles = {
            self.piles.items[1]:serialize(),
            self.piles.items[2]:serialize(),
            self.piles.items[3]:serialize(),
            self.piles.items[4]:serialize(),
        }
    }
end

function Solitaire:loadGame()
    local data = loadData('solitaire')
    if data and data.deck and data.wast and data.rows and data.piles then
        self:resetGame()

        self.seedValue = data.seedValue or self:nextSeedValue()
        self.score = data.score or 0

        Array.foreach(data.deck, function(card)
            self.deck:push(Card(card.value, card.suit, card.faceUp))
        end)
        Array.foreach(data.wast, function(card)
            self.wast:push(Card(card.value, card.suit, card.faceUp))
        end)
        Array.foreach(data.rows, function(row, i)
            Array.foreach(row, function(card)
                self.rows.items[i]:push(Card(card.value, card.suit, card.faceUp))
            end)
        end)
        Array.foreach(data.piles, function(pile, i)
            Array.foreach(pile, function(card)
                self.piles.items[i]:push(Card(card.value, card.suit, card.faceUp))
            end)
        end)
    end
end

function Solitaire:resetHistory()
    self.movesBack = Array()
    self.movesForward = Array()
end

function Solitaire:undo()
    if #self.movesBack > 1 then
        sketch:movement('undo')
        self:exec(self.movesBack, self.movesForward)
    end
end

function Solitaire:redo()
    self:exec(self.movesForward, self.movesBack)
end

function Solitaire:exec(from, to)
    if #from == 0 then return end
    local move = from:pop()
    to:push(move)
    move.moveFromTo(move.card, move.toDeck, move.fromDeck, i)
    move.toDeck, move.fromDeck = move.fromDeck, move.toDeck
end

function Solitaire:movement(type, fromDeck, toDeck)
    if type == 'faceup' then
        self.score = self.score + 10
        log('faceup')

    elseif type == 'movement' then
        if fromDeck.__className == 'Wast' and toDeck.__className == 'Row' then
            self.score = self.score + 10
            log('Wast to Row')

        elseif toDeck.__className == 'Pile' then
            self.score = self.score + 10
            log('to Pile')

        elseif fromDeck.__className == 'Pile' and toDeck.__className == 'Row' then
            self.score = self.score  - 5
            log('Pile to Row')
        end
    
    elseif type == 'undo' then
        self.score = self.score  - 20
        log('undo')
    end
end

function Solitaire:update(dt)
    if not (#self.tweenManager == 0 and self.autoPlay) then return end
    
    -- auto play
    local countCard = 0
    for i in range(self.rows:count()) do
        local lastCard = self.rows.items[i].items:last()
        if lastCard then
            local validMoves = Array()
            lastCard:getValidMovesFor(validMoves, self.piles.items, true)
            if #validMoves == 1 then
                lastCard:moveTo(validMoves[1], countCard)
                lastCard.autoPlay = true
                countCard = countCard + 1
            end
        end
    end
end

function Solitaire:draw()
    background(colors.green)

    local cards = Array()

    self.deckList:foreach(function(deck)
        deck:draw()
        for _, card in ipairs(deck.items) do
            if not card.tween then
                cards:add(card)
            end
        end
    end)

    self.deckList:foreach(function(deck)
        for _, card in ipairs(deck.items) do
            if card.tween and not card.faceUp then
                cards:add(card)
            end
        end
    end)

    self.deckList:foreach(function(deck)
        for _, card in ipairs(deck.items) do
            if card.tween and card.faceUp then
                cards:add(card)
            end
        end
    end)

    cards:foreach(function(card) card:draw() end)
end

---
Deck = class() : extends(Node)

function Deck:init(dx, dy)
    Node.init(self)

    self.reverseSearch = true

    self.dx = dx
    self.dy = dy

    self:reset()

    self.size = Anchor(7):size(1, 1):floor()
end

function Deck:reset()
    self.items = Array()
end

function Deck:changePosition(position)
    self.position:set(position)
end


AS = 1
VALET = 11
QUEEN = 12
KING = 13

suits = {
    heart = { name = 'coeur', color = 'red' },
    diamond = { name = 'carreau', color = 'red' },
    club = { name = 'trefle', color = 'black' },
    spade = { name = 'pique', color = 'black' },
}

function Deck:click()
    if (self == sketch.deck and
        #sketch.deck.items == 0 and
        #sketch.wast.items > 0)
    then
        for i in range(#sketch.wast.items) do
            local card = sketch.wast.items:first()
            card.faceUp = false
            card:moveToBottom(sketch.deck, i)
        end
    end
end

function Deck:serialize()
    local data = Array()
    self.items:foreach(function(card)
        data:push({
            value = card.value,
            suit = card.suit,
            faceUp = card.faceUp,
        })
    end)
    return data
end

function Deck:create()
    for _, suitName in ipairs { 'heart', 'diamond', 'club', 'spade' } do
        for value in range(13) do
            self:push(Card(value, suits[suitName], false))
        end
    end
end

function Deck:shuffle(seedValue)
    sketch.seedValue = seedValue or sketch:nextSeedValue()
    self.items:shuffle(sketch.seedValue)
end

function Deck:isMoveable()
    return true
end

function Deck:shift()
    for i=#self.items,2,-1 do
        self.items[i].nextPosition:set(self.items[i-1].nextPosition)
        self.items[i]:animate()
    end

    return Node.shift(self)
end

function Deck:push(card, count)
    -- compute next position
    if card.position == vec2() then
        card.position:set(self.position)
    end

    card.nextPosition = vec2()
    if #self.items == 0 then
        card.nextPosition:set(self.position.x, self.position.y)
    else
        local lastCard = self.items[#self.items]
        local dy = lastCard.faceUp and self.dy or self.dy/2
        card.nextPosition:set(
            lastCard.nextPosition.x + self.dx,
            lastCard.nextPosition.y + dy)
    end

    if card.tween then
        card.tween:finalize()
    end

    card:animate(count)

    self.items:push(card)
    card.deck = self
end

function Deck:draw()
    fill(Color(1, 1, 1, 0.2))
    stroke(Color(1, 1, 1))
    strokeSize(1)
    rect(self.position.x, self.position.y, Card.wcard, Card.hcard, Card.margin)
end

---
Wast = class() : extends(Deck)

function Wast:isMoveable(card)
    return card == self.items:last()
end

---
Pile = class() : extends(Deck)

function Pile:init(...)
    Deck.init(self, ...)
    self.pile = true
end

function Pile:isMoveable(card)
    return card == self.items:last()
end

function Pile:isValidMove(card, toDeck, autoPlay)
    if not card.faceUp then return false end
    if #toDeck.items == 0 then
        if card.value == AS then
            return true
        end
    else
        local last = toDeck.items:last()
        if (card.value == last.value + 1 and 
            card.suit.name == last.suit.name and 
            card == card.deck.items:last() and
            (
                not autoPlay or
                card.autoPlay == nil
            ))
        then
            return true
        end
    end
end

---
Row = class() : extends(Deck)

function Row:isMoveable(card)
    return card.faceUp
end

function Row:isValidMove(card, toDeck)
    if not card.faceUp then return false end

    if #toDeck.items == 0 then
        if card.value == KING then
            return true
        end
    else
        local last = toDeck.items:last()
        if card.value == last.value - 1 and card.suit.color ~= last.suit.color then
            return true
        end
    end
end

function Row:update()
    if #self.items > 0 and self.items:last().faceUp == false then
        sketch:movement('faceup')
        self.items:last().faceUp = true
    end
end

---
Card = class() : extends(Rect)

function Card.setup()
    Card.initSize()
end

function Card.initSize()
    if deviceOrientation == LANDSCAPE then
        Card.size = Anchor(nil, 7):size(1, 1):floor()
    else
        Card.size = Anchor(7):size(1, 1):floor()
    end
    Card.size.y = floor(Card.size.x * 1.5)

    Card.margin = Card.size.x / 10
    Card.radius = Card.size.x / 12

    Card.wcard = Card.size.x - Card.margin
    Card.hcard = Card.size.y - Card.margin

    Card.wtext = floor(Card.wcard * 0.45)
end

function Card:init(value, suit, faceUp)
    Rect.init(self, 0, 0, Card.wcard, Card.hcard)

    self.value = value
    self.suit = suit

    self.faceUp = faceUp

    self.img = Image(self.suit.name .. '.png')
end

function Card:animate(count)
    count = count or 0

    self.tween = animate(
        self.position,
        self.nextPosition,
        {
            delayBeforeStart = count / 60,
            delay = 20 / 60
        },
        tween.easing.quadOut,
        function() self.tween = nil end)    
end

local labels = { 'A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K' }

function Card:draw()
    local x, y = self.position.x, self.position.y

    local size = Card.size

    local innerMargin = Card.wcard / 20
    local radius = Card.radius

    local wcard = Card.wcard
    local hcard = Card.hcard
    local wtext = Card.wtext

    strokeSize(0.5)
    stroke(colors.black)
    fill(self.faceUp and (self.suit.color == 'red' and Color(1, 0.9, 0.9) or Color(0.9, 0.9, 0.9)) or colors.blue)
    rectMode(CORNER)
    rect(x, y, wcard, hcard, Card.radius)

    if self.faceUp then
        fontName('comic')
        fontSize(wtext)

        textMode(CENTER)
        textColor(self.suit.color == 'red' and colors.red or colors.black)
        text(labels[self.value],
            x + wtext / 2 + innerMargin,
            y + wtext / 2 + innerMargin)

        spriteMode(CENTER)
        sprite(self.img,
            x + wcard - wtext / 2 - innerMargin,
            y + wtext / 2 + innerMargin,
            wtext, wtext)

        sprite(self.img,
            x + wcard / 2,
            y + hcard - wcard / 2 - innerMargin,
            wcard * .7,
            wcard * .7)
    end
end

function Card:click()
    -- find first available move
    if self.tween and self.tween.state == 'running' then return end
    if not self.deck:isMoveable(self) then return end

    if self.deck == sketch.deck then
        local nCardsInDeck = #sketch.deck.items
        local nCardsToMove = min(sketch.play3Card and 3 or 1, nCardsInDeck)
        
        for i in range(#sketch.wast.items + nCardsToMove - 3) do
            local card = sketch.wast.items:first()
            card.faceUp = false
            card:moveToBottom(sketch.deck, i)
        end

        for i in range(nCardsToMove) do
            local card = sketch.deck.items:last()
            card.faceUp = true
            card:moveFromTo(sketch.deck, sketch.wast, i)
        end
        sketch:resetHistory()

    else
        local toDeck = self:getFirstValidMove()
        if toDeck then
            if self.deck.pile then
                self.autoPlay = false
            end
            self:moveTo(toDeck)
        end
    end

    sketch:saveGame()
end

function Card:moveTo(toDeck, countCard)
    countCard = countCard or 0

    sketch.movesBack:add({
        card = self,
        fromDeck = self.deck,
        toDeck = toDeck,
        moveFromTo = Card.moveFromTo,
    })

    sketch:movement('movement', self.deck, toDeck)
    self:moveFromTo(self.deck, toDeck, countCard)
end

function Card:moveFromTo(fromDeck, toDeck, countCard)
    countCard = countCard or 0

    local index = fromDeck.items:indexOf(self)

    while index <= #fromDeck.items do
        toDeck:push(fromDeck.items:remove(index), countCard)
        countCard = countCard + 1
    end
end

function Card:moveToBottom(toDeck, countCard)
    assert(self.deck:shift() == self)

    self.faceUp = false

    if self.tween then
        self.tween:finalize()
    end

    self.position:set(toDeck.position)
    self.nextPosition:set(self.position)
    
    toDeck.items:insert(1, self)
    self.deck = toDeck

    sketch:resetHistory()
end

function Card:getFirstValidMove()
    return self:getValidMoves()[1]
end

function Card:getValidMoves()
    local validMoves = Array()

    self:getValidMovesFor(validMoves, sketch.piles.items)
    self:getValidMovesFor(validMoves, sketch.rows.items)

    return validMoves
end

function Card:getValidMovesFor(validMoves, items, autoPlay)
    for _, item in ipairs(items) do
        if item:isValidMove(self, item, autoPlay) then
            validMoves:add(item)
        end
    end
end
