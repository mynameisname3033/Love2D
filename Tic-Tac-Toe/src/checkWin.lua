function checkWin(winSquares)
    for _, combo in ipairs(winCombos) do
        if string.find(table.concat(winSquares), combo[1]) and
            string.find(table.concat(winSquares), combo[2]) and
            string.find(table.concat(winSquares), combo[3]) then
            gameState = "end"
            return true
        end
    end

    return false
end