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

    clearCalc()

    addLabel('value', 2, row-1, colors.transparent, 2)

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
end

local function number(n)
    if decimalPart == 0 then
        acc1 = acc1 * 10 + tonumber(n)
    else
        acc1 = acc1 + tonumber(n) * 10^-decimalPart
        decimalPart = decimalPart + 1
    end
    value = acc1
end

local function decimal()
    if decimalPart == 0 then
        value = acc1
        decimalPart = 1
    end
end

local function percent()
    acc1 = acc1 / 100
    value = acc1
end

local function operation(op)
    if operator then
        acc2 = evaluateExpression(acc2..operator..acc1)
        acc1 = 0
        value = acc2
    else
        acc2 = acc1
        acc1 = 0
    end

    operator = op
    decimalPart = 0
end

local function compute()
    operation()
end

function clearCalc()
    acc1 = 0
    acc2 = 0
    operator = nil
    value = 0
    decimalPart = 0
end

function changeSign()
    acc1 = -acc1
    value = acc1
end 

local actions = {
    ['0'] = number,
    ['1'] = number,
    ['2'] = number,
    ['3'] = number,
    ['4'] = number,
    ['5'] = number,
    ['6'] = number,
    ['7'] = number,
    ['8'] = number,
    ['9'] = number,
    [','] = decimal,
    ['%'] = percent,
    ['+'] = operation,
    ['-'] = operation,
    ['x'] = function () operation('*') end,
    ['/'] = operation,
    ['='] = compute,
    ['AC'] = clearCalc,
    ['+/-'] = changeSign,
}

function action(ui)
    local action = actions[ui.label]
    if action then
        action(ui.label)
    end
end

function mousereleased(mouse)
    scene:mousereleased(mouse)
end

function draw()
    background(colors.black)
    scene:draw()
end
