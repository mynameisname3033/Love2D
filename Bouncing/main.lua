function love.load()
    square = {}
    square.width = 50
    square.height = 50
    square.x = love.graphics.getWidth() / 2
    square.y = love.graphics.getHeight() / 2

    local speedMagnitude = 500
    square.speedX = math.cos(love.math.random() * 2 * math.pi) * speedMagnitude
    square.speedY = math.sin(love.math.random() * 2 * math.pi) * speedMagnitude
end

function love.update(dt)
    square.x = square.x + square.speedX * dt
    square.y = square.y + square.speedY * dt

    if square.x <= 0 or square.x + square.width > love.graphics.getWidth() then
        square.speedX = -square.speedX
    end

    if square.y <= 0 or square.y + square.height > love.graphics.getHeight() then
        square.speedY = -square.speedY
    end
end

function love.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", square.x, square.y, square.width, square.height)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
        
    elseif key == "r" then
        love.load()
    end
end