local block = require 'block'

local board = {}

-- colors
BLACK = {0, 0, 0}
WHITE = {255, 255, 255}
GRAY = {125, 125, 125}

function board.draw_board()
    -- Draw wall
    love.graphics.setColor(love.math.colorFromBytes(GRAY))
    for i = 0, HEIGHT - 1 do
        for j = 0, WIDTH - 1 do
            if i == 0 or i == HEIGHT - 1 or j == 0 or j == WIDTH - 1 then
                love.graphics.rectangle("fill", j * SIZE, i * SIZE, SIZE, SIZE)
            end
        end
    end
    -- Draw placed blocks on the board
    for i = 0, HEIGHT - 1 do
        for j = 0, WIDTH - 1 do
            if board[i] and board[i][j] == "BLOCK" then
                love.graphics.setColor(love.math.colorFromBytes(159, 31, 11))
                love.graphics.rectangle("fill", j * SIZE, i * SIZE, SIZE, SIZE)
            end
        end
    end
    -- Draw the current active block
    if block.shape then
        love.graphics.setColor(love.math.colorFromBytes(block.color[1], block.color[2], block.color[3]))
        for i = 1, 4 do
            for j = 1, 4 do
                if block.shape[block.rotation][i][j] == 1 then
                    local board_x = block.x + j - 1
                    local board_y = block.y + i - 1
                    love.graphics.rectangle("fill", board_x * SIZE, board_y * SIZE, SIZE, SIZE)
                end
            end
        end
    end
    -- Draw grid
    love.graphics.setColor(love.math.colorFromBytes(WHITE))
    for i = 0, HEIGHT - 1 do
        for j = 0, WIDTH - 1 do
            love.graphics.rectangle("line", j * SIZE, i * SIZE, SIZE, SIZE)
        end
    end
end

function board.draw_sidebar()
    love.graphics.setFont(love.graphics.newFont(35))
    love.graphics.setColor(love.math.colorFromBytes(WHITE))
    love.graphics.print("TETRIS", margin + 3.3 * SIZE, 1 * SIZE)
    love.graphics.print("Score: 0", margin + 3 * SIZE, 7 * SIZE + SIZE / 2)

    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.print("SPACE - ROTATE", margin + 2.5 * SIZE, 16 * SIZE)
    love.graphics.print("ESC - QUIT", margin + 2.5 * SIZE, 18 * SIZE)
end

function board.set_fields()
    for i = 0, HEIGHT - 1 do
        board[i] = {}
        for j = 0, WIDTH - 1 do
            if i == 0 or i == HEIGHT - 1 or j == 0 or j == WIDTH - 1 then
                board[i][j] = "WALL"
            else
                board[i][j] = "FREE"
            end
        end
    end
end

return board