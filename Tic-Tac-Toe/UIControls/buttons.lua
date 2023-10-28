buttons = {}

function buttons.load()
    onePlayerButton = {}
    onePlayerButton.width = 150
    onePlayerButton.height = 50
    onePlayerButton.x = love.graphics.getWidth() / 2 - onePlayerButton.width / 2
    onePlayerButton.y = love.graphics.getHeight() / 2 - onePlayerButton.height / 2 - 75

    twoPlayerButton = {}
    twoPlayerButton.width = 150
    twoPlayerButton.height = 50
    twoPlayerButton.x = love.graphics.getWidth() / 2 - twoPlayerButton.width / 2
    twoPlayerButton.y = love.graphics.getHeight() / 2 - twoPlayerButton.height / 2 + 75

    backButton = {}
    backButton.width = 50
    backButton.height = 50
    backButton.x = 10
    backButton.y = 10
end

function buttons.draw_menu()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", onePlayerButton.x, onePlayerButton.y, onePlayerButton.width, onePlayerButton.height)
    love.graphics.rectangle("fill", twoPlayerButton.x, twoPlayerButton.y, twoPlayerButton.width, twoPlayerButton.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("One Player", onePlayerButton.x + onePlayerButton.width / 2 - myFontSmall:getWidth("One Player") / 2, onePlayerButton.y + onePlayerButton.height / 2 - myFontSmall:getHeight("One Player") / 2)
    love.graphics.print("Two Player", twoPlayerButton.x + twoPlayerButton.width / 2 - myFontSmall:getWidth("Two Player") / 2, twoPlayerButton.y + twoPlayerButton.height / 2 - myFontSmall:getHeight("Two Player") / 2)
end

function buttons.draw_back()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", backButton.x, backButton.y, backButton.width, backButton.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Back", backButton.x + backButton.width / 2 - myFontSmall:getWidth("Back") / 2 + 1, backButton.y + backButton.height / 2 - myFontSmall:getHeight("Back") / 2)
end