package.loaded['sketch.games.morpion'] = nil
require 'sketch.games.morpion'

function setup()
    M = 7
    N = 6

    MODE = 'puissance4'

    COUNT = 4
    
    createGame()
    createUI()
end

function drawBoard()
    background(colors.white)
    cells:foreach(drawCell)
end

function drawPlayer(value, w)
    noStroke()

    fill(colors.blue)
    rectMode(CENTER)
    rect(0, 0, cells.cellSize+1, cells.cellSize+1)

    if value == 'x' then
        fill(colors.yellow)

    elseif value == 'o' then
        fill(colors.red)

    else
        fill(colors.white)
    end

    circleMode(CENTER)
    circle(0, 0, w)
end
