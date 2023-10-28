init = {}

function init.load()
    playerTwoMoves, playerOneMoves, squares = {}, {}, {}
    game = "menu"
    gameState = ""
    currentPlayer = "Player1"
    filled = 0

    myFont = love.graphics.newFont("assets/fonts/1980.ttf", 128)
    myFontSmall = love.graphics.newFont("assets/fonts/1980.ttf", 32)

    winCombos = {
        {1, 2, 3}, {4, 5, 6}, {7, 8, 9},
        {1, 4, 7}, {2, 5, 8}, {3, 6, 9},
        {1, 5, 9}, {3, 5, 7}
    }
end