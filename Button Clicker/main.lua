function love.load()
    button = {
        x = 200,
        y = 150,
        size = 50
    }
    
    gameState = "start"
    startTimer = 3
    
    score = 0
    
    timer = 0
    timeLeft = 0.5
    
    myFont = love.graphics.newFont("assets/fonts/1980.ttf", 64)
    myFontSmall = love.graphics.newFont("assets/fonts/1980.ttf", 32)
    myFontStart = love.graphics.newFont("assets/fonts/pixeboy.ttf", 128)
    
    music = love.audio.newSource("assets/music/RetroPlatforming.mp3", "static")
    music:setVolume(0.2)
    music:play()
    
    volume = 1

    GameOver = love.audio.newSource("assets/sfx/GameOver.mp3", "static")
    
    threeTwoOneGo = love.audio.newSource("assets/sfx/321GO.mp3", "static")
    threeTwoOneGo:setVolume(1)
    threeTwoOneGo:play()
    
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
        timeLeft = timeLeft - dt
        timer = 30 - love.timer.getTime() + 3.5
        
        if timer <= 0 then
            GameOver:play()
            gameState = "Time's up!"
        end
        
        if love.timer.getTime() >= 5 and timer > 0 then
            music:setVolume(1)
        end
        
        if timeLeft <= 0 then
            button.x = math.random(button.size, love.graphics.getWidth() - button.size)
            button.y = math.random(150, love.graphics.getHeight() - button.size)
            
            timeLeft = 0.5
        end
    elseif gameState == "Time's up!" then
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
        
        love.graphics.setFont(myFont)
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.print(score, 50, 30)
        
        love.graphics.print("30.0", love.graphics.getWidth() - myFont:getWidth("30.0") - 50, 30)
    
    elseif gameState == "playing" then
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", button.x, button.y, button.size)
        
        love.graphics.setFont(myFontSmall)
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.print("High Score: " .. tostring(highScore), love.graphics.getWidth() / 2 - myFontSmall:getWidth(tostring("High Score: " .. highScore)) / 2, 30)

        love.graphics.setFont(myFont)
        
        love.graphics.print(score, 50, 30)
        
        love.graphics.print(string.format("%.1f", timer), love.graphics.getWidth() - myFont:getWidth(string.format("%.1f", timer)) - 50, 30)
    
    elseif gameState == "Time's up!" then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setFont(myFontStart)

        love.graphics.print("Time's up!", love.graphics.getWidth() / 2 - myFontStart:getWidth("Time's up!") / 2, love.graphics.getHeight() / 2 - myFontStart:getHeight("Time's up!") / 2)
        
        love.graphics.setFont(myFont)
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.print("Score: " .. tostring(score), love.graphics.getWidth() / 2 - myFont:getWidth(tostring("Score: " .. score)) / 2, love.graphics.getHeight() / 2 + 100 - myFont:getHeight(tostring("Score: " .. score)) / 2)
        love.graphics.print("High Score: " .. tostring(highScore), love.graphics.getWidth() / 2 - myFont:getWidth(tostring("High Score: " .. highScore)) / 2, (love.graphics.getHeight() / 2 + 100 - myFont:getHeight(tostring("High Score: " .. highScore)) / 2) - myFont:getHeight(tostring("Score: " .. score)) + 150)
        
        love.graphics.print(score, 50, 30)
        
        love.graphics.print("0.0", love.graphics.getWidth() - myFont:getWidth("0.0") - 50, 30)
    end
end

function love.mousepressed(x, y, b, isTouch)
    if gameState == "playing" and b == 1 then
        if math.sqrt((button.y - love.mouse.getY()) ^ 2 + (button.x - love.mouse.getX()) ^ 2) < button.size then
            score = score + 1
            
            button.x = math.random(button.size, love.graphics.getWidth() - button.size)
            button.y = math.random(150, love.graphics.getHeight() - button.size)
            
            timeLeft = 0.5
        
        else
            score = score - 1
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "r" and gameState == "Time's up!" then
        love.load()
    end
end