local block = require 'block'

local board = {}
local score = 0

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
    -- Set font and color for sidebar text
    love.graphics.setFont(love.graphics.newFont(35))
    love.graphics.setColor(love.math.colorFromBytes(WHITE))
    love.graphics.print("TETRIS", (WIDTH + 2.5) * SIZE, 1 * SIZE)
    love.graphics.setFont(love.graphics.newFont(25))
    love.graphics.print("SCORE: " .. tostring(score), (WIDTH + 1) * SIZE, 4 * SIZE)
    love.graphics.print("NEXT:", (WIDTH + 1) * SIZE, 7 * SIZE)

    -- Draw next block
    if block.next_shape then
        local next_block_x = (WIDTH + 2) * SIZE
        local next_block_y = 9 * SIZE

        love.graphics.setColor(love.math.colorFromBytes(WHITE))
        for i = 1, 4 do
            for j = 1, 4 do
                if block.next_shape[1][i][j] == 1 then
                    love.graphics.rectangle("fill", next_block_x + j * SIZE, next_block_y + (i - 1) * SIZE, SIZE, SIZE)
                end
            end
        end
    end

    love.graphics.print("SETTINGS:", (WIDTH + 1) * SIZE, 15 * SIZE)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.print("SPACE - Rotate", (WIDTH + 1) * SIZE, 17 * SIZE)
    love.graphics.print("A / D - Move Left / Right", (WIDTH + 1) * SIZE, 18 * SIZE)
    love.graphics.print("S - Drop", (WIDTH + 1) * SIZE, 19 * SIZE)
    love.graphics.print("ESC - Quit", (WIDTH + 1) * SIZE, 20 * SIZE)
end

function board.draw_game_over()
    love.graphics.setColor(love.math.colorFromBytes(WHITE))
    love.graphics.setFont(love.graphics.newFont(58))
    love.graphics.print("GAME OVER", SIZE, (HEIGHT - 4) * SIZE / 2)
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

function board.check_line()
    local lines_to_remove = {}
    for i = 1, HEIGHT - 2 do
        local is_full = true
        for j = 1, WIDTH - 2 do
            if board[i][j] ~= "BLOCK" then
                is_full = false
                break
            end
        end
        if is_full then
            table.insert(lines_to_remove, i)
        end
    end
    return lines_to_remove
end

function board.remove_line()
    local lines_to_remove = board.check_line()
    for _, line_index in ipairs(lines_to_remove) do
        for i = line_index, 2, -1 do
            for j = 1, WIDTH - 2 do
                board[i][j] = board[i - 1][j]
            end
        end
        for j = 1, WIDTH - 2 do
            board[1][j] = "FREE"
        end
    end
    local lines_removed = #lines_to_remove
    score = score + lines_removed * 10
    return lines_removed
end

return board