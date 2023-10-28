bot = {}

function bot.getMove()
    for _, combo in ipairs(winCombos) do
        local count, emptySquare = 0, 0

        for _, square in ipairs(combo) do
            if string.find(table.concat(playerTwoMoves), square) then count = count + 1
            elseif not string.find(table.concat(playerOneMoves), square) then emptySquare = square end
        end

        if count == 2 and emptySquare ~= 0 then return emptySquare end
    end

    for _, combo in ipairs(winCombos) do
        local count, emptySquare = 0, 0

        for _, square in ipairs(combo) do
            if string.find(table.concat(playerOneMoves), square) then count = count + 1
            elseif not string.find(table.concat(playerTwoMoves), square) then emptySquare = square end
        end

        if count == 2 and emptySquare ~= 0 then return emptySquare end
    end

    if filled == 1 and playerOneMoves[1] ~= 5 then return 5
    elseif filled == 1 and playerOneMoves[1] == 5 then
        local emptyGoodSquares = {1, 3, 7, 9}
        return emptyGoodSquares[math.random(#emptyGoodSquares)]

    elseif #playerOneMoves == 2 then
        local possibleForkBlocks = {}
    
        if string.find(table.concat(playerOneMoves), 5) and (string.find(table.concat(playerOneMoves), 1) or string.find(table.concat(playerOneMoves), 3) or
        string.find(table.concat(playerOneMoves), 7) or string.find(table.concat(playerOneMoves), 9)) then possibleForkBlocks = {1, 3, 7, 9}

        elseif playerOneMoves[1] % 2 == 0 and playerOneMoves[2] % 2 == 0 then
            if string.find(table.concat(playerOneMoves), 6) and string.find(table.concat(playerOneMoves), 8) or
            string.find(table.concat(playerOneMoves), 2) and string.find(table.concat(playerOneMoves), 4) or
            string.find(table.concat(playerOneMoves), 2) and string.find(table.concat(playerOneMoves), 6) or
            string.find(table.concat(playerOneMoves), 4) and string.find(table.concat(playerOneMoves), 8) then
                local goodSquare = (math.ceil(playerOneMoves[1] / 3) - 1) * 3 + (playerOneMoves[2] - 1) % 3 + 1
                if goodSquare ~= 1 and goodSquare ~= 3 and goodSquare ~= 7 and goodSquare ~= 9 then
                    goodSquare = (math.ceil(playerOneMoves[2] / 3) - 1) * 3 + (playerOneMoves[1] - 1) % 3 + 1
                end
                return goodSquare
            end

            possibleForkBlocks = {1, 3, 7, 9}
            
        elseif playerOneMoves[2] % 2 == 0 and playerOneMoves[1] % 2 == 1 or playerOneMoves[1] % 2 == 0 and playerOneMoves[2] % 2 == 1 then
            local goodSquare = (math.ceil(playerOneMoves[1] / 3) - 1) * 3 + (playerOneMoves[2] - 1) % 3 + 1
            if goodSquare ~= 1 and goodSquare ~= 3 and goodSquare ~= 7 and goodSquare ~= 9 then
                goodSquare = (math.ceil(playerOneMoves[2] / 3) - 1) * 3 + (playerOneMoves[1] - 1) % 3 + 1
            end
            return goodSquare

        else possibleForkBlocks = {2, 4, 6, 8} end
    
        local block = possibleForkBlocks[math.random(#possibleForkBlocks)]
        while string.find(table.concat(playerOneMoves), block) or string.find(table.concat(playerTwoMoves), block) do block = possibleForkBlocks[math.random(#possibleForkBlocks)] end
        return block
    end

    local bestMove, maxWaysToWin = -1, -1

    for i, square in ipairs(squares) do
        if not string.find(table.concat(playerTwoMoves), i) and not string.find(table.concat(playerOneMoves), i) then
            local waysToWin = 0

            for _, combo in ipairs(winCombos) do
                if string.find(table.concat(combo), i) then
                    local canWin = true
                    for _, squareInCombo in ipairs(combo) do
                        if string.find(table.concat(playerOneMoves), squareInCombo) then
                            canWin = false
                            break
                        end
                    end

                    if canWin then waysToWin = waysToWin + 1 end
                end
            end

            if math.random(2) == 1 then
                if waysToWin > maxWaysToWin then
                    maxWaysToWin = waysToWin
                    bestMove = i
                end
            else
                if waysToWin >= maxWaysToWin then
                    maxWaysToWin = waysToWin
                    bestMove = i
                end
            end
        end
    end

    return bestMove
end