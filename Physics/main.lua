function love.load()
    camera = require "libs/camera"
    cam = camera()
    
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 10 * 64, true)

    myFont = love.graphics.newFont("assets/fonts/Font.ttf", 24)

    objects = {}
    
    objects.cameras = {
        mainCamObject = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() - 600 / 2},
    }
    objects.cameras.right = {}
    objects.cameras.left = {}
    
    for i = 1, 10000 do
        cameraData = {
            x = love.graphics.getWidth() / 2 + i * love.graphics.getWidth(),
            y = love.graphics.getHeight() - 600 / 2
        }
        table.insert(objects.cameras.right, cameraData)
    end
    
    for i = 1, 10000 do
        cameraData = {
            x = love.graphics.getWidth() / 2 - i * love.graphics.getWidth(),
            y = love.graphics.getHeight() - 600 / 2
        }
        table.insert(objects.cameras.left, cameraData)
    end
    
    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() - 50 / 2)
    objects.ground.shape = love.physics.newRectangleShape(1000000, 50)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
    
    objects.ball = {}
    objects.ball.body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "dynamic")
    objects.ball.shape = love.physics.newCircleShape(20)
    objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
    objects.ball.fixture:setRestitution(0.75)
    objects.ball.maxSpeed = 10000
    
    objects.block1 = {}
    objects.block1.body = love.physics.newBody(world, 200, 550, "dynamic")
    objects.block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
    objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 5)
    
    objects.block2 = {}
    objects.block2.body = love.physics.newBody(world, 200, 400, "dynamic")
    objects.block2.shape = love.physics.newRectangleShape(0, 0, 100, 50)
    objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 2)
    
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
    love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight())
end

function love.update(dt)
    vx, vy = objects.ball.body:getLinearVelocity()

    world:update(dt)
    
    if love.keyboard.isDown("right") and vx < objects.ball.maxSpeed then
        objects.ball.body:applyForce(500, 0)

    elseif vx > objects.ball.maxSpeed then
        objects.ball.body:setLinearVelocity(objects.ball.maxSpeed, vy)
    end
    
    if love.keyboard.isDown("left") and vx > -objects.ball.maxSpeed then
        objects.ball.body:applyForce(-500, 0)

    elseif vx < -objects.ball.maxSpeed then
        objects.ball.body:setLinearVelocity(-objects.ball.maxSpeed, vy)
    end
    
    if love.keyboard.isDown("up") and objects.ball.body:getY() + objects.ball.shape:getRadius() + 26 >= objects.ground.body:getY() then
        objects.ball.body:setLinearVelocity(vx, -400)
    end

    if not (love.keyboard.isDown("right") or love.keyboard.isDown("left")) and objects.ball.body:getY() + objects.ball.shape:getRadius() + 26 >= objects.ground.body:getY() then
        objects.ball.body:setLinearDamping(0.6)

    elseif not (love.keyboard.isDown("right") or love.keyboard.isDown("left")) and objects.ball.body:getY() + objects.ball.shape:getRadius() + 26 < objects.ground.body:getY() then
        objects.ball.body:setLinearDamping(0.2)
    
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("left") then
        objects.ball.body:setLinearDamping(0)
    end
    
    for i, camData in ipairs(objects.cameras.right) do
        if objects.ball.body:getX() > camData.x - love.graphics.getWidth() / 2 then
            cam:lookAt(camData.x, camData.y)
        end
    end
    
    for i, camData in ipairs(objects.cameras.left) do
        if objects.ball.body:getX() < camData.x + love.graphics.getWidth() / 2 then
            cam:lookAt(camData.x, camData.y)
        end
    end
    
    if objects.ball.body:getX() > 0 and objects.ball.body:getX() < love.graphics.getWidth() then
        cam:lookAt(objects.cameras.mainCamObject.x, objects.cameras.mainCamObject.y)
    end
end

function love.draw()
    love.graphics.setFont(myFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(string.format("Speed: %d", math.floor(math.abs(tonumber(vx)))), love.graphics.getWidth() / 2 - myFont:getWidth(string.format("Speed: %d", math.floor(math.abs(tonumber(vx))))) / 2, 0)

    cam:attach()
        love.graphics.setColor(0.28, 0.63, 0.05)
        love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
        
        love.graphics.setColor(0.76, 0.18, 0.05)
        love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
        
        love.graphics.setColor(0.20, 0.20, 0.20)
        love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
        love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))
    cam:detach()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
        
    elseif key == "r" then
        love.load()
    end
end