--blocks
local T = {
    {0,0},
    {-1,0},
    {1,0},
    {0,1}
}

local I = {
    {0,0},
    {-1,0},
    {1,0},
    {2,0}
}

local O = {
    {0,0},
    {1,0},
    {0,1},
    {1,1}
}

local L = {
    {0,0},
    {0,-1},
    {0,1},
    {1,1}
}

local J = {
    {0,0},
    {0,-1},
    {0,1},
    {-1,1}
}

local S = {
    {0,0,},
    {1,0},
    {0,1},
    {-1,1}
}

local Z = {
    {0,0,},
    {-1,0},
    {0,1},
    {1,1}
}

local currentPiece = {
    x = 0,
    y = 0,
    shape = O
}

--starting parameters
block_size = 30
gap = 50
width = 10
height = 20
lines_scored = 0
gravity_timer = 0
blocks = {T, I, O, L, S, Z, J}
gameOver = false

function rotatePiece(piece)
    if piece.shape == O then
        return O
    end
    local rotated = {}
    for i, block in ipairs(piece.shape) do
        local x = block[1]
        local y = block[2]
        rotated[i] = {-y, x}
    end
    return rotated
end

function moveDown(piece)
    piece.y = piece.y+1
    return piece
end

function createGrid(width, height)
    local grid = {}
    for y = 1, height do
        grid[y] = {}

        for x = 1, width do
            grid[y][x] = false
        end
    end
    return grid
end

function drawGrid(grid)
    for y, row in ipairs(grid) do
        for x, cell in ipairs(row) do        
            local mode = "line"
            if grid[y][x] then
                love.graphics.setColor(0.5,0,0.5)
                mode = "fill"
            end
            love.graphics.rectangle(mode, (gap + ((x-1) * block_size)), (gap + ((y-1) * block_size)), block_size, block_size)
            love.graphics.setColor(1,1,1)
        end
    end
end

function drawUI(width, height)
    love.graphics.printf("score: ".. score, block_size*width + gap*2, gap, 150, "left")
    love.graphics.printf("Level: ".. level, block_size*width + gap*2, gap + 50, 150, "left")
end

function lockPiece(grid, piece)
    for i, block in ipairs(piece.shape) do
        local x = piece.x + block[1]
        local y = piece.y + block[2]
        if y >= 1 and y <= height and x >= 1 and x <= width then
            grid[y][x] = true
        end
    end
end

function clearLines(grid)
    local y = height
    while y >= 1 do
        local fullLine = true
        for x = 1, width do
            if not grid[y][x] then
                fullLine = false
                break
            end
        end

        if fullLine then
            table.remove(grid, y)
            local emptyRow = {}
            for x = 1, width do
                emptyRow[x] = false
            end
            table.insert(grid, 1, emptyRow)
            lines_scored = lines_scored + 1
            score = score + level * 100
        else
            y = y - 1
        end
    end
end

function spawnBlock()
    local shape = blocks[math.random(#blocks)]
    currentPiece = {
        x = math.ceil(width/2),
        y = 1,
        shape = shape
    }
    if checkCollision(grid ,currentPiece.x, currentPiece.y) then
        gameOver = true
    end
    
end

function drawBlock(piece)
    for i, block in ipairs(piece.shape) do
        local x = piece.x + block[1]
        local y = piece.y + block[2]
        love.graphics.setColor(0,0.5,0.5)
        love.graphics.rectangle("fill", (gap + ((x-1) * block_size)), (gap + ((y-1) * block_size)), block_size, block_size)
        love.graphics.setColor(1,1,1)
    end
end

function love.load()
    success = love.window.setMode(700, 700, {resizable=false, centered=true})
    grid = createGrid(width,height)
    score = 0
    level = 1
    font = love.graphics.newFont(20)
    love.graphics.setFont(font)
    spawnBlock()
end

function love.update(dt)
    if gameOver then
        return
    end
    gravity_timer = gravity_timer + dt*(math.floor(level/2)+1)
    if gravity_timer >= 1 then
        local movedPiece = moveDown(currentPiece)
        if not checkCollision(grid, movedPiece.x, movedPiece.y) then
            currentPiece = movedPiece
        else
            lockPiece(grid, currentPiece)
            clearLines(grid)
            spawnBlock()
        end
        gravity_timer = 0
    end

    level = math.floor(lines_scored / 4) + 1
end

-- board draw loop
function love.draw()
    drawGrid(grid)
    drawUI(width, height)
    drawBlock(currentPiece)

    if gameOver then
        love.graphics.setColor(1,0,0)
        love.graphics.printf("Game Over", 0, 300, 700, "center")
        love.graphics.printf("Final Score: "..score, 0, 350, 700, "center")
        love.graphics.printf("Press R to Restart or Esc to exit", 0, 400, 700, "center")
        love.graphics.setColor(1,1,1)
    end
end

function checkCollision(grid, x, y)
    for i, block in ipairs(currentPiece.shape) do
        local blockX = x + block[1]
        local blockY = y + block[2]
        if blockX < 1 or blockX > width or blockY > height then
            return true
        end
        if blockY >= 1 and grid[blockY][blockX] then
            return true
        end
    end
    return false
end


function love.keypressed(key)
    if key == "left" and not gameOver then
        if not checkCollision(grid, currentPiece.x-1, currentPiece.y) then
            currentPiece.x = currentPiece.x - 1
        end
    elseif key == "right" and not gameOver then
        if not checkCollision(grid, currentPiece.x+1, currentPiece.y) then
            currentPiece.x = currentPiece.x + 1
        end
    elseif key == "up" and not gameOver then
        local rotatedPiece = rotatePiece(currentPiece)

        local oldPiece = currentPiece.shape
        currentPiece.shape = rotatedPiece

        if checkCollision(grid, currentPiece.x, currentPiece.y) then
            currentPiece.shape = oldPiece
        end

    elseif key == "space" and not gameOver then
        while true do
            if not checkCollision(grid, currentPiece.x, currentPiece.y+1) then
                currentPiece.y = currentPiece.y + 1
            else
                lockPiece(grid, currentPiece)
                clearLines(grid)
                spawnBlock()
                break
            end
        end
    elseif key == "r" then
        if gameOver then
            grid = createGrid(width,height)
            score = 0
            level = 1 
            lines_scored = 0
            gameOver = false
            gravity_timer = 0
            spawnBlock()
        end
    elseif key == "escape" and gameOver then
        love.graphics.clear()
        love.event.quit()
    end

end
