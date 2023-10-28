endgame = {}

function endgame.check()
    love.graphics.setFont(myFont)
    love.graphics.setColor(0, 0, 0)

    if checkWin(playerOneMoves) then
        if game == "one_player_game" then
            love.graphics.print("You won!", love.graphics.getWidth() / 2 - myFont:getWidth("You won!") / 2, love.graphics.getHeight() / 2 - myFont:getHeight("You won!") / 2)
        else
            love.graphics.print("Player 1 won!", love.graphics.getWidth() / 2 - myFont:getWidth("Player 1 won!") / 2, love.graphics.getHeight() / 2 - myFont:getHeight("Player 1 won!") / 2)
        end
        love.graphics.setFont(myFontSmall)
        love.graphics.print("Press any key to replay", love.graphics.getWidth() / 2 - myFontSmall:getWidth("Press any key to replay") / 2, love.graphics.getHeight() - 45)

    elseif checkWin(playerTwoMoves) then
        if game == "one_player_game" then
            love.graphics.print("The bot won!", love.graphics.getWidth() / 2 - myFont:getWidth("The bot won!") / 2, love.graphics.getHeight() / 2 - myFont:getHeight("The bot won!") / 2)
        else
            love.graphics.print("Player 2 won!", love.graphics.getWidth() / 2 - myFont:getWidth("Player 2 won!") / 2, love.graphics.getHeight() / 2 - myFont:getHeight("Player 2 won!") / 2)
        end
        love.graphics.setFont(myFontSmall)
        love.graphics.print("Press any key to replay", love.graphics.getWidth() / 2 - myFontSmall:getWidth("Press any key to replay") / 2, love.graphics.getHeight() - 45)
        
    elseif filled == 9 then
        gameState = "end"
        love.graphics.print("Draw!", love.graphics.getWidth() / 2 - myFont:getWidth("Draw!") / 2, love.graphics.getHeight() / 2 - myFont:getHeight("Draw!") / 2)
        love.graphics.setFont(myFontSmall)
        love.graphics.print("Press any key to replay", love.graphics.getWidth() / 2 - myFontSmall:getWidth("Press any key to replay") / 2, love.graphics.getHeight() - 45)
    end
end