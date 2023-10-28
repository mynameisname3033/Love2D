function love.load()
    camera = require "libs/camera"
    cam = camera()

    myFont = love.graphics.newFont("assets/fonts/1980.ttf", 128)
    myFontSmaller = love.graphics.newFont("assets/fonts/1980.ttf", 80)
    myFontSmall = love.graphics.newFont("assets/fonts/1980.ttf", 32)

    gameOver = love.audio.newSource("assets/sfx/GameOver.mp3", "static")
    jump = love.audio.newSource("assets/sfx/jump.wav", "static")
    music = love.audio.newSource("assets/music/music.mp3", "static")
    music:play()

    volume, score = 1, 0
    sound = true
    playerState, game = "", ""

    button = {}
    button.width = 40
    button.height = 40
    button.x = love.graphics.getWidth() - 10 - button.width
    button.y = 10

    world = love.physics.newWorld(-500, 9.18 * 35, false)

    ground = {}
    ground.width = 10000000000
    ground.height = 50
    ground.body = love.physics.newBody(world, love.graphics.getWidth() / 2 - ground.width / 2, love.graphics.getHeight() - 25)
    ground.shape = love.physics.newRectangleShape(ground.width, ground.height)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)

    player = {}
    player.width = 50
    player.height = 50
    player.maxSpeed = 700
    player.body = love.physics.newBody(world, love.graphics.getWidth() / 2 - player.width / 2, ground.body:getY() - player.height, "dynamic")
    player.shape = love.physics.newRectangleShape(player.width, player.height)
    player.fixture = love.physics.newFixture(player.body, player.shape)

    obstacles = {}
    local lastObstacleX = math.random(-50, player.body:getX() - 300)
    for i = 1, 200 do
        math.randomseed(math.random(os.time()))

        obstacles[i] = {}
        obstacles[i].width = 20
        obstacles[i].height = i + math.random(20, 30)
        obstacles[i].x = lastObstacleX - (i == 1 and lastObstacleX or obstacles[1].height * 40) - math.random(350)
        lastObstacleX = lastObstacleX - (i == 1 and lastObstacleX or obstacles[1].height * 40) - math.random(350)
        obstacles[i].y = ground.body:getY() - obstacles[i].height
    end

    for i, obstacle in ipairs(obstacles) do
        if math.random(2) == 1 then
            local newObstacle = {}
            newObstacle.width = 20
            newObstacle.height = obstacle.height + math.random(-10, 10)
            newObstacle.x = obstacle.x - 40
            newObstacle.y = ground.body:getY() - newObstacle.height

            table.insert(obstacles, newObstacle)
        end
    end
end

function love.mousepressed(x, y, key)
    if key == 1 and x >= button.x and x <= button.x + button.width and y >= button.y and y <= button.y + button.height then
        sound = not sound
        if sound then music:setVolume(volume)
        else music:setVolume(0) end
    end
end

function love.update(dt)
    if game ~= "end" then world:update(dt) end

    if game == "end" and sound then
        volume = volume - 0.1 * dt
        music:setVolume(volume)
    end

    vx, vy = player.body:getLinearVelocity()

    if #obstacles == 0 then game = "end" end

    for i, obstacle in ipairs(obstacles) do
        if player.body:getX() > obstacle.x and player.body:getX() < obstacle.x + obstacle.width and
        player.body:getY() >= obstacle.y - player.height and game ~= "end" then
            game = "end"
            if sound then gameOver:play() end
        end

        if obstacle.x >= player.body:getX() + love.graphics.getWidth() / 2 + player.width then
            table.remove(obstacles, i)
            score = score + 1
        end
    end

    if player.body:getY() + player.height < ground.body:getY() - 1 then playerState = "air"
    else playerState = "ground" end

    player.body:setLinearVelocity(math.max(vx, -player.maxSpeed), vy)
    cam:lookAt(player.body:getX(), ground.body:getY() - love.graphics.getHeight() / 2 + ground.height)

    if sound then music:play()
    else music:stop() end
end

function love.draw()
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

    cam:attach()
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", player.body:getX(), player.body:getY(), player.width, player.height)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", ground.body:getX(), ground.body:getY(), ground.width, ground.height)

        love.graphics.setColor(0, 0, 0)
        for _, obstacle in ipairs(obstacles) do love.graphics.rectangle("fill", obstacle.x, obstacle.y, obstacle.width, obstacle.height) end
    cam:detach()

    love.graphics.setFont(myFontSmaller)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(score, 11, 0)

    if game == "end" then
        love.graphics.setFont(myFont)
        love.graphics.setColor(1, 1, 1)

        if #obstacles > 0 then
            love.graphics.print("Game Over!", love.graphics.getWidth() / 2 - myFont:getWidth("Game Over!") / 2, love.graphics.getHeight() / 2 - myFont:getHeight("Game Over!") / 2)
        else
            love.graphics.print("You won!", love.graphics.getWidth() / 2 - myFont:getWidth("You won!") / 2, love.graphics.getHeight() / 2 - myFont:getHeight("You won!") / 2)
        end

        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(myFontSmall)
        love.graphics.print("Press any button to restart", love.graphics.getWidth() / 2 - myFontSmall:getWidth("Press any button to restart") / 2, ground.body:getY() - myFontSmall:getHeight("Press any button to restart") / 2)
    end
end

function love.keypressed(key)
    if playerState == "ground" and (key == "up" or key == "w" or key == "space") and game ~= "end" then player.body:applyForce(0, -(obstacles[1].height * 350 + 75000))

    elseif key == "escape" then love.event.quit()
    elseif key == "r" or game == "end" then
        music:stop()
        local prevSound = sound
        love.load()
        sound = prevSound
    end
end