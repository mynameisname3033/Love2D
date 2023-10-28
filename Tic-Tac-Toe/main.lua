function love.load()
    require "pathFinder"

    buttons.load()
    init.load()
    squares_init.load()
end

function love.mousepressed(x, y, button)
    if game == "menu" then
        if x >= onePlayerButton.x and x <= onePlayerButton.x + onePlayerButton.width and y >= onePlayerButton.y and y <= onePlayerButton.y + onePlayerButton.height then
            game = "one_player_game"

        elseif x >= twoPlayerButton.x and x <= twoPlayerButton.x + twoPlayerButton.width and y >= twoPlayerButton.y and y <= twoPlayerButton.y + twoPlayerButton.height then
            game = "two_player_game"
        end

    elseif game == "one_player_game" and button == 1 then
        if x >= backButton.x and x <= backButton.x + backButton.width and y >= backButton.y and y <= backButton.y + backButton.height then love.load() end
            
        for i, square in ipairs(squares) do
            if x >= square.x and x <= square.x + square.width and y >= square.y and y <= square.y + square.height and
            not string.find(table.concat(playerOneMoves), i) and not string.find(table.concat(playerTwoMoves), i) and gameState ~= "end" then
                table.insert(playerOneMoves, i)
                filled = filled + 1
                checkWin(playerOneMoves)
        
                if filled < 9 and gameState ~= "end" then
                    table.insert(playerTwoMoves, bot.getMove())
                    filled = filled + 1
                end
        
                break
            end
        end

    elseif button == 1 then
        if x >= backButton.x and x <= backButton.x + backButton.width and y >= backButton.y and y <= backButton.y + backButton.height then love.load() end

        for i, square in ipairs(squares) do
            if x >= square.x and x <= square.x + square.width and y >= square.y and y <= square.y + square.height and
            not string.find(table.concat(playerOneMoves), i) and not string.find(table.concat(playerTwoMoves), i) and gameState ~= "end" then
                if currentPlayer == "Player1" then
                    table.insert(playerOneMoves, i)
                else
                    table.insert(playerTwoMoves, i)
                end
                filled = filled + 1
                currentPlayer = currentPlayer == "Player1" and "Player2" or "Player1"
            end
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0.21, 0.57, 0.53)
    love.graphics.setFont(myFontSmall)

    if game == "menu" then
        buttons.draw_menu()
    else
        if game == "two_player_game" then
            if filled % 2 == 0 and gameState ~= "end" then love.graphics.print("Player 1's turn!", love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Player 1's turn!") / 2, 25)
            elseif gameState ~= "end" then love.graphics.print("Player 2's turn!", love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Player 2's turn!") / 2, 25) end
        elseif filled == 0 then love.graphics.print("You go first!", love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("You go first!") / 2, 25) end

        squares_init.draw()

        for _, oneMove in ipairs(playerOneMoves) do
            love.graphics.line(squares[oneMove].x, squares[oneMove].y, squares[oneMove].x + squares[oneMove].width, squares[oneMove].y + squares[oneMove].height)
            love.graphics.line(squares[oneMove].x + squares[oneMove].width, squares[oneMove].y, squares[oneMove].x, squares[oneMove].y + squares[oneMove].height)
        end

        for _, twoMove in ipairs(playerTwoMoves) do love.graphics.circle("line", squares[twoMove].x + squares[twoMove].width / 2, squares[twoMove].y + squares[twoMove].height / 2, squares[twoMove].width / 2) end

        buttons.draw_back()
        endgame.check()
    end
end

function love.keypressed(key)
    hotkeys.check(key)
end