function love.load()
    camera = require "libs/camera"
    cam = camera()

    game = "start"
    score, volume = 0, 0.75
    sound, written = true, false
    pipes = {}

    myFont = love.graphics.newFont("assets/fonts/1980.ttf", 64)
    myFontSmall = love.graphics.newFont("assets/fonts/1980.ttf", 32)
    myFontBig = love.graphics.newFont("assets/fonts/pixeboy.ttf", 128)
    
    music = love.audio.newSource("assets/music/music.mp3", "static")
    music:setVolume(volume)
    music:play()

    jump = love.audio.newSource("assets/sfx/jump.wav", "static")
    gameOver = love.audio.newSource("assets/sfx/gameOver.mp3", "static")

    if love.filesystem.read("highscore.txt") then highScore = love.filesystem.read("highscore.txt")
    else highScore = 0 end

    button = {}
    button.width = 40
    button.height = 40
    button.x = 10
    button.y = love.graphics.getHeight() - 10 - button.height

    world = love.physics.newWorld(100, 9.18 * 75, false)

    player = {}
    player.width = 40
    player.height = 40
    player.maxSpeed = 250
    player.body = love.physics.newBody(world, love.graphics.getWidth() / 2 - player.width / 2, love.graphics.getHeight() / 2 - player.height / 2, "dynamic")
    player.shape = love.physics.newRectangleShape(player.width, player.height)
    player.fixture = love.physics.newFixture(player.body, player.shape)
end

function love.mousepressed(x, y, key)
    if key == 1 and x >= button.x and x <= button.x + button.width and y >= button.y and y <= button.y + button.height then
        sound = not sound
        if sound then music:setVolume(volume)
        else music:setVolume(0) end
    end
end

function love.update(dt)
    if game ~= "start" then
        world:update(dt)

        vx, vy = player.body:getLinearVelocity()

        if #pipes == 0 or pipes[1][2].x < player.body:getX() - 100 and not pipes[1].done then
            if #pipes > 0 then pipes[1].done = true end

            math.randomseed(math.random(os.time()))
            local upperPipe = {width = 50, height = math.random(0, love.graphics.getHeight() - 150), x = player.body:getX() + love.graphics.getWidth() / 2 + 20, y = 0}
            local lowerPipe = {width = 50, height = love.graphics.getHeight() - upperPipe.height + 150, x = upperPipe.x, y = upperPipe.height + 150}
            table.insert(pipes, {upperPipe, lowerPipe})
        end

        for i, pipePair in ipairs(pipes) do
            if pipePair[1].x < player.body:getX() - player.width - love.graphics.getWidth() / 2 then table.remove(pipes, i) end
            if pipePair[2].x + pipePair[1].width < player.body:getX() and not pipePair[2].done and game ~= "end" then
                score = score + 1
                pipePair[2].done = true
            end

            if player.body:getX() + player.width > pipePair[1].x and player.body:getX() < pipePair[1].x + pipePair[1].width and
            (player.body:getY() < pipePair[1].height or player.body:getY() + player.height > pipePair[2].y) and game ~= "end" then
                game = "end"
                if sound then gameOver:play() end
            end
        end

        if vx >= player.maxSpeed then player.body:setLinearVelocity(player.maxSpeed, vy) end
        if player.body:getY() + player.height >= love.graphics.getHeight() and game ~= "end" then
            game = "end"
            if sound then gameOver:play() end
        end
        player.body:setY(math.max(0, math.min(love.graphics.getHeight() - player.height, player.body:getY())))

        if game == "end" and sound then
            volume = volume - 0.1 * dt
            music:setVolume(volume)
        end
    end

    cam:lookAt(player.body:getX(), love.graphics.getHeight() / 2)
    if score > tonumber(highScore) then highScore = score end

    if not sound then music:stop()
    else music:play() end
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0.64, 1)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
    
    cam:attach()
        love.graphics.setColor(0.35, 1, 0)
        for _, pipePair in ipairs(pipes) do
            love.graphics.rectangle("fill", pipePair[1].x, pipePair[1].y, pipePair[1].width, pipePair[1].height)
            love.graphics.rectangle("fill", pipePair[2].x, pipePair[2].y, pipePair[2].width, pipePair[2].height)
        end

        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("fill", player.body:getX(), player.body:getY(), player.width, player.height)
    cam:detach()

    love.graphics.setFont(myFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(score, 11, 0)

    if game == "end" then
        love.graphics.setFont(myFontBig)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("Game Over", love.graphics.getWidth() / 2 - myFontBig:getWidth("Game Over") / 2, love.graphics.getHeight() / 2 - myFontBig:getHeight("Game Over") / 2)
        love.graphics.setFont(myFontSmall)
        love.graphics.print("Press any button to restart", love.graphics.getWidth() / 2 - myFontSmall:getWidth("Press any button to restart") / 2, love.graphics.getHeight() - myFontSmall:getHeight("Press any button to restart") / 2 - 125)
        love.graphics.setFont(myFont)
        love.graphics.print("High Score: " .. tostring(highScore), love.graphics.getWidth() / 2 - myFont:getWidth(tostring("High Score: " .. highScore)) / 2, love.graphics.getHeight() / 2 + 100 - myFont:getHeight(tostring("High Score: " .. highScore)) / 2)

        world:setGravity(0, 9.18 * 75)
        player.body:setLinearDamping(1)

        if not written and score == tonumber(highScore) then
            love.filesystem.write("highscore.txt", highScore)
            written = true
        end

    elseif game == "start" then
        love.graphics.setFont(myFont)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("Press any button to start", love.graphics.getWidth() / 2 - myFont:getWidth("Press any button to start") / 2, love.graphics.getHeight() / 2 + 50)
        love.graphics.print("High Score: " .. tostring(highScore), love.graphics.getWidth() / 2 - myFont:getWidth(tostring("High Score: " .. highScore)) / 2, love.graphics.getHeight() / 2 + 175 - myFont:getHeight(tostring("High Score: " .. highScore)) / 2)
    
    else
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(myFont)
        love.graphics.print("High Score: " .. tostring(highScore), love.graphics.getWidth() - myFont:getWidth(tostring("High Score: " .. highScore)) - 11, 0) 
    end
end

function love.keypressed(key)
    if (key == "up" or key == "space" or key == "w") and game ~= "end" and game ~= "start" then
        player.body:setLinearVelocity(vx, -300)
        if sound then jump:play() end

    elseif key == "escape" then love.event.quit()
    elseif key == "r" or game == "end" then
        music:stop()
        local prevSound = sound
        love.load()
        sound = prevSound
        
    else game = "started" end
end
