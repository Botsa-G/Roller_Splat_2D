-- requiring other scripts
require "block"
require "player"
require "collision"
require "particles"
require "background"

local sounds = {}
sounds.victory = love.audio.newSource("victory.wav", "static")
sounds.hit = love.audio.newSource("slam.wav", "static")
sounds.roll = love.audio.newSource("roll.wav", "static")
sounds.background = love.audio.newSource("BG.ogg", "static")
local fonts = {}
fonts.first = love.graphics.newFont("sho.ttf", 35)
local winTextX = -400
local winTextY = 50
local expectedWinTextX = 80
local lerpSpeed = 10

local initialYDown
local initialXDown
local swipeMinLength = 5
local HasNotReleased = false
local gameWon = false

local startY = 150
local slideSpeed = 500

local cool = 0
local picked = false
local pickUp
local skyblue = {0.2, 1, 1}
local possibleColors = { -- blue =
{0, 0, 1}, -- red =
{1, 0, 0}, -- green =
{0, 1, 0}, -- yellow=
{1, 1, 0.1}, -- orange=
{1, 0.6, 0.1}}

-- Creating a particle effect 

local particleEffects = {}
function CreateParticle(tab)
    particleEffects[#particleEffects + 1] = particle:new(tab)
end
-- Setting particles direction
function ParticlesToTheLeft(x, y)
    for i = 1, 360, 4 do
        CreateParticle({
            x = x,
            y = y,
            angle = i,
            life = math.random(0, 1),
            radius = math.random(0.5, 2),
            weight = math.random(0.5, 1.5),
            position = "left",
            speed = math.random(15, 20)
        })
    end
end
function ParticlesToTheRight(x, y)
    for i = 1, 360, 4 do
        CreateParticle({
            x = x,
            y = y,
            angle = i,
            life = math.random(0, 1),
            radius = math.random(0.5, 2),
            weight = math.random(0.5, 1.5),
            position = "right",
            speed = math.random(15, 20)
        })
    end
end
function ParticlesUp(x, y)
    for i = 1, 360, 4 do
        CreateParticle({
            x = x,
            y = y,
            angle = i,
            life = math.random(0, 1),
            radius = math.random(0.5, 2),
            weight = math.random(0.5, 1.5),
            position = "up",
            speed = math.random(15, 20)
        })
    end
end
function ParticlesDown(x, y)
    for i = 1, 360, 4 do
        CreateParticle({
            x = x,
            y = y,
            angle = i,
            life = math.random(0, 1),
            radius = math.random(0.5, 2),
            weight = math.random(0.5, 1.5),
            position = "down",
            speed = math.random(15, 20)
        })
    end
end
-- Creating the game blocks
local blocks = {}
function CreateBlock(tab)
    blocks[#blocks + 1] = block:new(tab)
end

levelOne = {{1, 1, 1, 0, 1, 1, 1},
            {1, 0, 1, 0, 1, 0, 1},
            {1, 0, 1, 1, 1, 1, 1},
            {1, 0, 1, 0, 1, 1, 1},
            {1, 0, 1, 0, 1, 1, 1},
            {1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 1, 1, 1, 1}}

levelTwo = {{0, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 1, 1, 1, 1},
            {1, 1, 0, 0, 0, 0, 0},
            {1, 1, 0, 1, 1, 1, 1},
            {1, 1, 1, 0, 0, 0, 1},
            {1, 1, 1, 1, 1, 1, 1},
            {1, 0, 1, 0, 0, 0, 1},
            {0, 0, 1, 1, 1, 1, 1}}

MouseX, MouseY = love.mouse.getPosition()
local selectedColor
local blockSize = 34

-- check for a swipe
function CheckForSwipe()
    if love.mouse.isDown(1) == false then
        HasNotReleased = false
    end
    if love.mouse.isDown(1) then
        if MouseX ~= 0 and HasNotReleased == false then
            initialXDown = MouseX
            initialYDown = MouseY
            HasNotReleased = true
        end
        local xDist = (MouseX - initialXDown)
        local yDist = math.abs((MouseY - initialYDown))
        if xDist > swipeMinLength and yDist > swipeMinLength and xDist > yDist then
            return "right"
        end
    end

    if love.mouse.isDown(1) == false then
        HasNotReleased = false
    end
    if love.mouse.isDown(1) then
        if MouseX ~= 0 and HasNotReleased == false then
            initialXDown = MouseX
            initialYDown = MouseY
            HasNotReleased = true
        end
        local xDist = (MouseX - initialXDown)
        local yDist = math.abs((MouseY - initialYDown))
        if xDist < -swipeMinLength and yDist > swipeMinLength and math.abs(xDist) > yDist then
            return "left"
        end
    end

    if love.mouse.isDown(1) == false then
        HasNotReleased = false
    end
    if love.mouse.isDown(1) then
        if MouseX ~= 0 and HasNotReleased == false then
            initialXDown = MouseX
            initialYDown = MouseY
            HasNotReleased = true
        end
        local xDist = math.abs(MouseX - initialXDown)
        local yDist = ((MouseY - initialYDown))
        if yDist < -swipeMinLength and xDist > swipeMinLength and math.abs(yDist) > xDist then
            return "up"
        end
    end

    if love.mouse.isDown(1) == false then
        HasNotReleased = false
    end
    if love.mouse.isDown(1) then
        if MouseX ~= 0 and HasNotReleased == false then
            initialXDown = MouseX
            initialYDown = MouseY
            HasNotReleased = true
        end
        local xDist = math.abs(MouseX - initialXDown)
        local yDist = ((MouseY - initialYDown))
        if yDist > swipeMinLength and xDist > swipeMinLength and math.abs(yDist) > xDist then
            return "down"
        end
    end

end

local screenWidth = 360

local horizontalcount = 9
local horizontalgap = (screenWidth - blockSize * horizontalcount) * 0.5

function love.load()

    Background = background:new()

    math.randomseed(os.time())
    selectedColor = possibleColors[math.floor(math.random(1, #possibleColors))]

    henry = player:new({
        x = horizontalgap + (blockSize / 2) + blockSize,
        y = startY + blockSize * (horizontalcount - 1)
    })

    for i = 1, #levelOne do
        for j = 1, #levelOne[i] do
            local state
            if levelOne[i][j] == 1 then
                state = "pathway"
            else
                state = "barrier"
            end
            CreateBlock({
                x = horizontalgap + (blockSize / 2) + blockSize * j,
                y = startY + blockSize * i,
                identity = state
            })
        end
    end

    -- Horizonal Outer Barriers
    for a = 0, 8 do
        CreateBlock({
            x = horizontalgap + (blockSize / 2) + blockSize * a,
            y = startY,
            identity = "barrier",
            position = "exterior"
        })
        CreateBlock({
            x = horizontalgap + (blockSize / 2) + blockSize * a,
            y = startY + blockSize * horizontalcount,
            identity = "barrier",
            position = "exterior"
        })

    end

    -- vertical Outer Barriers
    for b = 1, 8 do
        CreateBlock({
            x = horizontalgap + (blockSize / 2),
            y = startY + blockSize * b,
            identity = "barrier",
            position = "exterior"
        })
        CreateBlock({
            x = screenWidth - (blockSize / 2 + horizontalgap),
            y = startY + blockSize * b,
            identity = "barrier",
            position = "exterior"
        })
    end

end

function CheckForWin()
    for i = 1, #blocks do
        if blocks[i].identity == "pathway" and blocks[i].colorNumber == 1 then
            return true
        end
    end
end

function love.update(dt)
    sounds.background:setVolume(0.2)
    sounds.background:play()

    CheckForSwipe()
    if cool > 0 then
        cool = cool - dt
    end
    MouseX, MouseY = love.mouse.getPosition()
    henry.r = selectedColor[1] * 0.9
    henry.g = selectedColor[2] * 0.9
    henry.b = selectedColor[3] * 0.9

    for i = 1, #blocks do
        if blocks[i].identity == "barrier" then
            blocks[i].r = 0.75
            blocks[i].g = 0.75
            blocks[i].b = 0.75
        end
        if blocks[i].colorNumber == 2 then
            blocks[i].r = selectedColor[1]
            blocks[i].g = selectedColor[2]
            blocks[i].b = selectedColor[3]
        end
    end

    if henry.swipeToRight then
        ParticlesToTheLeft(henry.x, henry.y)
    end

    if henry.swipeToLeft then
        ParticlesToTheRight(henry.x, henry.y)
    end

    if henry.swipeDown then
        ParticlesUp(henry.x, henry.y)
    end

    if henry.swipeUp then
        ParticlesDown(henry.x, henry.y)
    end

    -- Coloring
    for x = 1, #blocks do
        if distance(blocks[x].x, blocks[x].y, henry.x, henry.y) < blockSize and blocks[x].identity ~= "barrier" and
            blocks[x].colorNumber ~= 2 then
            blocks[x].colorNumber = 2
        end
    end

    -- right move
    if henry.swipeToRight then
        if picked then
            pickUp = henry:SwipeRight(blocks)
            picked = false
        end
        if henry.x < pickUp and henry:SwipeRight(blocks) ~= nil and henry.x ~= nil then
            print(pickUp)
            henry.x = henry.x + slideSpeed * dt
            sounds.roll:play()
        elseif henry.x >= pickUp then
            sounds.roll:stop()
            sounds.hit:play()
            henry.x = pickUp
            henry.swipeToRight = false
        end
    end

    -- left move    
    if henry.swipeToLeft then
        if picked then
            pickUp = henry:SwipeLeft(blocks) or (horizontalgap + block.width + block.width * 0.5)
            picked = false
        end

        if henry.x > pickUp then
            print(pickUp, henry:SwipeLeft(blocks), henry.swipeToLeft)
            henry.x = henry.x - slideSpeed * dt
            sounds.roll:play()
        elseif henry.x <= pickUp then
            sounds.roll:stop()
            sounds.hit:play()
            henry.x = pickUp
            henry.swipeToLeft = false
        end
    end

    -- up move
    if henry.swipeUp then
        if picked then
            pickUp = henry:SwipeUp(blocks) or (startY + block.height)
            picked = false
        end

        if henry.y > pickUp then
            print(pickUp, henry:SwipeUp(blocks), henry.swipeUp)
            henry.y = henry.y - slideSpeed * dt
            sounds.roll:play()
        elseif henry.y <= pickUp then
            sounds.roll:stop()
            sounds.hit:play()
            henry.y = pickUp
            henry.swipeUp = false
        end
    end

    -- down move 
    if henry.swipeDown then
        if picked then
            pickUp = henry:SwipeDown(blocks)
            picked = false
        end
        if henry.y < pickUp and henry:SwipeDown(blocks) ~= nil and henry.y ~= nil then
            print(henry:SwipeDown(blocks), henry.swipeDown)
            henry.y = henry.y + slideSpeed * dt
            sounds.roll:play()
        elseif henry.y >= pickUp then
            sounds.roll:stop()
            sounds.hit:play()
            henry.y = pickUp
            henry.swipeDown = false
        end
    end

    -- Confirm victory
    if CheckForWin() ~= true then
        if gameWon == false then
            sounds.victory:play()
            gameWon = true
        end
        winTextX = lerp(expectedWinTextX, winTextX, lerpSpeed * dt)
        sounds.background:stop()
    end

    for i = 1, #blocks do
        if blocks[i].identity == "pathway" and blocks[i].colorNumber == 1 then

            if CheckForSwipe() == "right" and cool <= 0 and henry.swipeToLeft == false and henry.swipeUp == false and
                henry.swipeDown == false then
                henry.swipeToRight = true
                picked = true
                cool = 0.5
            end
            if love.keyboard.isDown("right") and cool <= 0 and henry.swipeToLeft == false and henry.swipeUp == false and
                henry.swipeDown == false then
                henry.swipeToRight = true
                picked = true
                cool = 0.5
            end

            if CheckForSwipe() == "left" and cool <= 0 and henry.swipeToRight == false and henry.swipeUp == false and
                henry.swipeDown == false then
                henry.swipeToLeft = true
                picked = true
                cool = 0.5
            end
            if love.keyboard.isDown("left") and cool <= 0 and henry.swipeToRight == false and henry.swipeUp == false and
                henry.swipeDown == false then
                henry.swipeToLeft = true
                picked = true
                cool = 0.5
            end

            if CheckForSwipe() == "up" and cool <= 0 and henry.swipeToRight == false and henry.swipeToLeft == false and
                henry.swipeDown == false then
                henry.swipeUp = true
                picked = true
                cool = 0.5
            end
            if love.keyboard.isDown("up") and cool <= 0 and henry.swipeToRight == false and henry.swipeToLeft == false and
                henry.swipeDown == false then
                henry.swipeUp = true
                picked = true
                cool = 0.5
            end

            if CheckForSwipe() == "down" and cool <= 0 and henry.swipeToRight == false and henry.swipeToLeft == false and
                henry.swipeUp == false then
                henry.swipeDown = true
                picked = true
                cool = 0.5
            end
            if love.keyboard.isDown("down") and cool <= 0 and henry.swipeToRight == false and henry.swipeToLeft == false and
                henry.swipeUp == false then
                henry.swipeDown = true
                picked = true
                cool = 0.5
            end

        end
    end

    for p = 1, #particleEffects do
        pa = particleEffects[p]
        pa.x = pa.x + pa.speed * math.cos(math.rad(pa.angle)) * dt
        pa.y = pa.y + pa.speed * math.sin(math.rad(pa.angle)) * dt
        pa.gravity = pa.gravity + pa.weight
        pa.radius = pa.radius - dt
        pa.r = selectedColor[1] * 0.9
        pa.g = selectedColor[2] * 0.9
        pa.b = selectedColor[3] * 0.9

        -- Update particle movements
        if pa.position == "left" then
            pa.x = pa.x - pa.gravity * dt
        end
        if pa.position == "right" then
            pa.x = pa.x + pa.gravity * dt
        end
        if pa.position == "up" then
            pa.y = pa.y - pa.gravity * dt
        end
        if pa.position == "down" then
            pa.y = pa.y + pa.gravity * dt
        end
    end

    for i = #particleEffects, 1, -1 do
        if particleEffects[i].life <= 0 or particleEffects[i].radius <= 0 then
            table.remove(particleEffects, i)
        end
    end
end

function love.draw()

    Background:draw()

    for i = 1, #blocks do
        blocks[i]:draw()
    end

    for p = 1, #particleEffects do
        particleEffects[p]:draw()
    end

    henry:draw()

    print(CheckForWin())

    love.graphics.setFont(fonts.first)
    love.graphics.print("You Win", winTextX, winTextY)

end

