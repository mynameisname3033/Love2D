function love.load()
    gameState = "start"
    startTimer = 3
    
    myFont = love.graphics.newFont("assets/fonts/1980.ttf", 64)
    myFontSmall = love.graphics.newFont("assets/fonts/1980.ttf", 32)
    myFontStart = love.graphics.newFont("assets/fonts/pixeboy.ttf", 128)
    
    enemyImage = love.graphics.newImage("assets/sprites/enemy.png")
    playerImage = love.graphics.newImage("assets/sprites/player.png")
    
    music = love.audio.newSource("assets/music/music.mp3", "static")
    music:setVolume(0.2)
    music:play()
    
    hit = love.audio.newSource("assets/sfx/hit.wav", "static")
    hitEnemy = love.audio.newSource("assets/sfx/hitEnemy.mp3", "static")
    
    GameOver = love.audio.newSource("assets/sfx/GameOver.mp3", "static")
    
    endExplosion = love.audio.newSource("assets/sfx/endExplosion.mp3", "static")
    
    threeTwoOneGo = love.audio.newSource("assets/sfx/321GO.mp3", "static")
    threeTwoOneGo:setVolume(1)
    threeTwoOneGo:play()
    
    volume = 0.375
    
    player = {
        x = love.graphics.getWidth() / 2 - playerImage:getWidth() / 2,
        y = love.graphics.getHeight() - playerImage:getHeight() - 25,
        width = playerImage:getWidth(),
        height = playerImage:getHeight(),
        health = 100,
        speed = 750
    }
    
    lasers = {}
    enemyLasers = {}
    
    laserTimer = 0
    laserSpawnInterval = 0.25
    
    enemies = {}
    
    enemyTimer = 0
    enemySpawnInterval = 1
    
    score = 0
    timer = 0
    highScore = 0
    
    highScoreFile = "highScore.txt"
    
    if love.filesystem.getInfo(highScoreFile) then
        local loadedScore = love.filesystem.read(highScoreFile)
        
        if loadedScore then
            highScore = loadedScore
        else
            highScore = 0
        end
    end
end

function love.update(dt)
    if gameState == "start" then
        startTimer = startTimer - dt
        
        if startTimer <= 0 then
            gameState = "playing"
        end
    
    elseif gameState == "playing" then
        timer = timer + dt
        
        if player.health <= 0 then
            GameOver:play()
            gameState = "GameOver"
        end
        
        if love.timer.getTime() >= 5 then
            music:setVolume(0.375)
        end
        
        if love.keyboard.isDown("left") then
            player.x = player.x - player.speed * dt
        
        elseif love.keyboard.isDown("right") then
            player.x = player.x + player.speed * dt
        end
        
        player.x = math.max(0, math.min(love.graphics.getWidth() - player.width, player.x))
        
        for i, enemy in ipairs(enemies) do
            enemy.y = enemy.y + 375 * dt
            
            enemy.fireTimer = enemy.fireTimer + dt
            
            if enemy.fireTimer >= 2 then
                enemyLaser = {
                    x = enemy.x + (enemy.width - 5) / 2,
                    y = enemy.y + enemy.height,
                    width = 5,
                    height = 10
                }
                table.insert(enemyLasers, enemyLaser)
                
                enemy.fireTimer = 0
            end
            
            if player.x < enemy.x + enemy.width and
                player.x + player.width > enemy.x and
                player.y < enemy.y + enemy.height and
                player.y + player.height > enemy.y then
                
                hit:play()
                
                player.health = player.health - 20
                table.remove(enemies, i)
            end
            
            if enemy.y > love.graphics.getHeight() then
                endExplosion:play()
                player.health = player.health - 30
                table.remove(enemies, i)
            end
        end
        
        for j, enemyLaser in ipairs(enemyLasers) do
            enemyLaser.y = enemyLaser.y + 500 * dt
            
            if enemyLaser.y > love.graphics.getHeight() then
                table.remove(enemyLasers, j)
            
            elseif player.x < enemyLaser.x + enemyLaser.width and
                player.x + player.width > enemyLaser.x and
                player.y < enemyLaser.y + enemyLaser.height and
                player.y + player.height > enemyLaser.y then
                
                hit:play()
                
                table.remove(enemyLasers, j)
                player.health = player.health - 10
            end
        end
        
        enemyTimer = enemyTimer + dt
        
        if enemyTimer >= enemySpawnInterval then
            math.randomseed(os.time())
            
            newEnemy = {
                x = math.random(10, love.graphics.getWidth() - enemyImage:getWidth() - 10),
                y = -1 - enemyImage:getHeight(),
                width = enemyImage:getWidth(),
                height = enemyImage:getHeight(),
                fireTimer = 0
            }
            
            enemyLaser = {
                x,
                y = newEnemy.y + 25,
                width = 5,
                height = 10
            }
            enemyLaser.x = newEnemy.x + (newEnemy.width - enemyLaser.width) / 2
            
            table.insert(enemyLasers, enemyLaser)
            table.insert(enemies, newEnemy)
            
            enemyTimer = 0
        end
        
        for i, laser in ipairs(lasers) do
            laser.y = laser.y - 375 * dt
            
            if laser.y < 0 then
                table.remove(lasers, i)
            end
            
            for j, enemy in ipairs(enemies) do
                if laser.x < enemy.x + enemy.width and
                    laser.x + laser.width > enemy.x and
                    laser.y < enemy.y + enemy.height and
                    laser.y + laser.height > enemy.y then
                    
                    hitEnemy:play()
                    
                    score = score + 1
                    
                    table.remove(enemies, j)
                    break
                end
            end
        end
        
        laserTimer = laserTimer + dt
        
        if laserTimer >= laserSpawnInterval then
            newLaser = {
                x,
                y = player.y - 25,
                width = 5,
                height = 10
            }
            newLaser.x = player.x + (player.width - newLaser.width) / 2
            table.insert(lasers, newLaser)
            
            laserTimer = 0
        end
    
    elseif gameState == "GameOver" then
        volume = volume - 0.1 * dt
        music:setVolume(volume)
        
        if score > tonumber(highScore) then
            highScore = score
            
            love.filesystem.write(highScoreFile, tostring(highScore), all)
        end
    end
end

function love.draw()
    if gameState == "start" then
        love.graphics.setFont(myFontStart)
        love.graphics.setColor(1, 0, 0)
        love.graphics.print(math.ceil(startTimer), love.graphics.getWidth() / 2 - myFontStart:getWidth(tostring(math.ceil(startTimer))) / 2, love.graphics.getHeight() / 2 - myFontStart:getHeight(math.ceil(startTimer)) / 2)
        
        if startTimer <= 2 then
            love.graphics.setColor(1, 1, 0)
            love.graphics.print(math.ceil(startTimer), love.graphics.getWidth() / 2 - myFontStart:getWidth(tostring(math.ceil(startTimer))) / 2, love.graphics.getHeight() / 2 - myFontStart:getHeight(math.ceil(startTimer)) / 2)
        end
        
        if startTimer <= 1 then
            love.graphics.setColor(0, 1, 0)
            love.graphics.print(math.ceil(startTimer), love.graphics.getWidth() / 2 - myFontStart:getWidth(tostring(math.ceil(startTimer))) / 2, love.graphics.getHeight() / 2 - myFontStart:getHeight(math.ceil(startTimer)) / 2)
        end
        
        love.graphics.setFont(myFont)
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.print("High Score: " .. tostring(highScore), love.graphics.getWidth() / 2 - myFont:getWidth(tostring("High Score: " .. highScore)) / 2, love.graphics.getHeight() / 2 + 100 - myFont:getHeight(tostring("High Score: " .. highScore)) / 2)
        
        love.graphics.print(score, 50, 30)
        
        love.graphics.print("0.0", love.graphics.getWidth() - myFont:getWidth("0.0") - 50, 30)
    
    elseif gameState == "playing" then
        love.graphics.setFont(myFontSmall)
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.print("High Score: " .. tostring(highScore), love.graphics.getWidth() / 2 - myFontSmall:getWidth(tostring("High Score: " .. highScore)) / 2, 30)
        
        love.graphics.setFont(myFont)
        
        love.graphics.print(score, 50, 30)
        
        love.graphics.print(string.format("%.1f", timer), love.graphics.getWidth() - myFont:getWidth(string.format("%.1f", timer)) - 50, 30)
        
        local healthX
        
        if player.x < love.graphics.getWidth() / 2 - player.width / 2 then
            healthX = player.x + player.width / 2 - myFont:getWidth(tostring(player.health)) / 2 + 100
        else
            healthX = player.x + player.width / 2 - myFont:getWidth(tostring(player.health)) / 2 - 100
        end
        
        love.graphics.setFont(myFont)
        love.graphics.print(player.health, healthX, player.y + player.height / 2 - myFont:getHeight(healthText) / 2)
        
        for _, enemy in ipairs(enemies) do
            love.graphics.setColor(1, 1, 1)
            
            love.graphics.draw(enemyImage, enemy.x, enemy.y)
            
            love.graphics.setColor(1, 0, 0)
            
            for _, enemyLaser in ipairs(enemyLasers) do
                love.graphics.rectangle("fill", enemyLaser.x, enemyLaser.y, enemyLaser.width, enemyLaser.height)
            end
        end

        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(playerImage, player.x, player.y)

        for _, laser in ipairs(lasers) do
            love.graphics.rectangle("fill", laser.x, laser.y, laser.width, laser.height)
        end
    
    elseif gameState == "GameOver" then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setFont(myFontStart)
        love.graphics.print("Game Over", love.graphics.getWidth() / 2 - myFontStart:getWidth("Game Over") / 2, love.graphics.getHeight() / 2 - myFontStart:getHeight("Game Over") / 2)
        
        love.graphics.setFont(myFont)
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.print("Score: " .. tostring(score), love.graphics.getWidth() / 2 - myFont:getWidth(tostring("Score: " .. score)) / 2, love.graphics.getHeight() / 2 + 100 - myFont:getHeight(tostring("Score: " .. score)) / 2)
        love.graphics.print("High Score: " .. tostring(highScore), love.graphics.getWidth() / 2 - myFont:getWidth(tostring("High Score: " .. highScore)) / 2, (love.graphics.getHeight() / 2 + 100 - myFont:getHeight(tostring("High Score: " .. highScore)) / 2) - myFont:getHeight(tostring("Score: " .. score)) + 150)
        
        love.graphics.print(score, 50, 30)
        
        love.graphics.print(string.format("%.1f", timer), love.graphics.getWidth() - myFont:getWidth(string.format("%.1f", timer)) - 50, 30)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "r" and gameState == "GameOver" then
        love.load()
    end
end