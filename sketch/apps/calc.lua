function setup()
    scene = Scene()

    anchor = Anchor(4)

    function addLabel(label, i, j, clr, len)
        addInterface(UIExpression, label, i, j, clr, len)
    end
    
    function addButton(label, i, j, clr, len)
        addInterface(UIButton, label, i, j, clr, len).callback = action
    end
    
    function addInterface(ui, label, i, j, clr, len)
        len = len or 1
        local instance = ui(label)
            :setPosition(anchor:pos(i-0.95, j-0.95))
            :setSize(anchor:size(len-0.1, 0.9))
            :attrib{
                styles = {
                    mode = CENTER,
                    fontSize = 32,
                    radiusBorder = 32,
                    fillColor = clr,
                }
            }
        scene:add(instance)
        return instance
    end

    local row = anchor.nj - anchor.ni - 0.5

    calc = Calc()

    addLabel('calc.value', 2, row-1, colors.transparent, 2)

    addButton('/', 4, row+0, colors.orange)
    addButton('x', 4, row+1, colors.orange)
    addButton('-', 4, row+2, colors.orange)
    addButton('+', 4, row+3, colors.orange)
    addButton('=', 4, row+4, colors.orange)

    addButton('AC', 1, row, colors.gray)
    addButton('+/-', 2, row, colors.gray)
    addButton('%', 3, row, colors.gray)

    row = row + 1
    addButton('7', 1, row, colors.blue)
    addButton('8', 2, row, colors.blue)
    addButton('9', 3, row, colors.blue)

    row = row + 1
    addButton('4', 1, row, colors.blue)
    addButton('5', 2, row, colors.blue)
    addButton('6', 3, row, colors.blue)

    row = row + 1
    addButton('1', 1, row, colors.blue)
    addButton('2', 2, row, colors.blue)
    addButton('3', 3, row, colors.blue)

    row = row + 1
    addButton('0', 1, row, colors.blue, 2)
    addButton(',', 3, row, colors.blue)

    parameter:watch('calc.acc1')
    parameter:watch('calc.acc2')
    parameter:watch('calc.decimalPart')
    parameter:watch('calc.operator')
    parameter:watch('calc.sign')
end

function action(ui)
    local action = Calc.actions[ui.label]
    if action then
        action(calc, ui.label)
    end
end

function mousereleased(mouse)
    scene:mousereleased(mouse)
end

function draw()
    background(colors.black)
    scene:draw()
end

Calc = class()

function Calc.setup()
    Calc.actions = {
        ['0'] = Calc.number,
        ['1'] = Calc.number,
        ['2'] = Calc.number,
        ['3'] = Calc.number,
        ['4'] = Calc.number,
        ['5'] = Calc.number,
        ['6'] = Calc.number,
        ['7'] = Calc.number,
        ['8'] = Calc.number,
        ['9'] = Calc.number,
        [','] = Calc.decimal,
        ['%'] = Calc.percent,
        ['+'] = Calc.operation,
        ['-'] = Calc.operation,
        ['x'] = function () calc:operation('*') end,
        ['/'] = Calc.operation,
        ['='] = Calc.compute,
        ['AC'] = Calc.init,
        ['+/-'] = Calc.changeSign,
    }
end

function Calc:init()
    self.acc1 = 0
    self.acc2 = 0
    self.decimalPart = 0
    self.operator = nil
    self.sign = 1
    self.value = 0    
end

function Calc:number(n)
    if self.decimalPart == 0 then
        self.acc1 = self.sign * abs(self.acc1 * 10 + tonumber(n))
    else
        self.acc1 = self.sign * abs(self.acc1 + tonumber(n) * (10^-self.decimalPart))
        self.decimalPart = self.decimalPart + 1
    end
    self.value = self.acc1
end

function Calc:decimal()
    if self.decimalPart == 0 then
        self.value = self.acc1
        self.decimalPart = 1
    end
end

function Calc:percent()
    self.acc1 = self.acc1 / 100
    self.decimalPart = math. self.acc1
    self.value = self.acc1
end

function Calc:operation(op)
    if self.operator then
        self.acc2 = evaluateExpression(self.acc2..self.operator..self.acc1)
        self.acc1 = 0
        self.value = self.acc2
    else
        self.acc2 = self.acc1
        self.acc1 = 0
    end

    self.operator = op
    self.decimalPart = 0
end

function Calc:compute()
    self:operation()
    self.acc1 = self.acc2
    self.acc2 = 0
end

function Calc:changeSign()
    self.sign = -self.sign
    self.acc1 = -self.acc1
    self.value = self.acc1
end

function Calc.unitTest()
    local calc = Calc()

    calc:init()
    assert(calc.value == 0)

    calc:number(1)
    calc:number(2)
    calc:number(3)
    assert(calc.value == 123)

    calc:operation('+')
    calc:number(1)
    calc:number(2)
    calc:number(3)
    calc:compute()
    assert(calc.value == 246)

    calc:operation('/')
    calc:number('123')
    calc:compute()
    assert(calc.value == 2)
end
