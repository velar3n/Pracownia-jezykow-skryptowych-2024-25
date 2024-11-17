local board = {}

-- grid parameters
WIDTH, HEIGHT, SIZE = 12, 25, 35
local margin = WIDTH * SIZE

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

return board