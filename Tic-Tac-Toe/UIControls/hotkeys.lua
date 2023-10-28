hotkeys = {}

function hotkeys.check(key)
    if key == "escape" then love.event.quit()
    elseif key == "b" then love.load()
    elseif key == "1" and game == "menu" then game = "one_player_game"
    elseif key == "2" and game == "menu" then game = "two_player_game"
    
    elseif key == "r" or gameState == "end" then
        local prevGame = game
        love.load()
        game = prevGame
    end
end