squares_init = {}

function squares_init.load()
    for i = 1, 9 do
        squares[i] = {}
        squares[i].width = 100
        squares[i].height = 100
        squares[i].x = love.graphics.getWidth() / 2 - (i % 3 == 1 and 175 or i % 3 == 2 and 0 or -175) - squares[i].width / 2
        squares[i].y = love.graphics.getHeight() / 2 - (i <= 3 and 175 or (i > 3 and i <= 6) and 0 or -175) - squares[i].height / 2
    end
end

function squares_init.draw()
    love.graphics.setColor(1, 1, 1)
    for _, square in ipairs(squares) do love.graphics.rectangle("fill", square.x, square.y, square.width, square.height) end
    love.graphics.setColor(1, 0, 0)
end