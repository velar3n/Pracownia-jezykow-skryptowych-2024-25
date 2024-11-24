
local block = {}

-- all 7 classic tetris blocks with all 4 of their rotations
local shapes = {
    {{{0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}},
   {{0, 0, 0, 0}, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0, 0, 0}},
   {{0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}},
   {{0, 0, 0, 0}, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0, 0, 0}}}, -- I
   {{{1, 0, 0, 0}, {1, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},
   {{0, 1, 1, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}, {0, 0, 0, 0}},
   {{0, 0, 0, 0}, {1, 1, 1, 0}, {0, 0, 1, 0}, {0, 0, 0, 0}},
   {{0, 1, 0, 0}, {0, 1, 0, 0}, {1, 1, 0, 0}, {0, 0, 0, 0}}}, -- J
   {{{0, 0, 1, 0}, {1, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},
   {{0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}},
   {{0, 0, 0, 0}, {1, 1, 1, 0}, {1, 0, 0, 0}, {0, 0, 0, 0}},
   {{1, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}, {0, 0, 0, 0}}}, -- L
   {{{0, 1, 1, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},
   {{0, 1, 1, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},
   {{0, 1, 1, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},
   {{0, 1, 1, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}}, -- O
   {{{0, 1, 1, 0}, {1, 1, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},
   {{0, 1, 0, 0}, {0, 1, 1, 0}, {0, 0, 1, 0}, {0, 0, 0, 0}},
   {{0, 0, 0, 0}, {0, 1, 1, 0}, {1, 1, 0, 0}, {0, 0, 0, 0}},
   {{1, 0, 0, 0}, {1, 1, 0, 0}, {0, 1, 0, 0}, {0, 0, 0, 0}}}, -- S
   {{{0, 1, 0, 0}, {1, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},
   {{0, 1, 0, 0}, {0, 1, 1, 0}, {0, 1, 0, 0}, {0, 0, 0, 0}},
   {{0, 0, 0, 0}, {1, 1, 1, 0}, {0, 1, 0, 0}, {0, 0, 0, 0}},
   {{0, 1, 0, 0}, {1, 1, 0, 0}, {0, 1, 0, 0}, {0, 0, 0, 0}}}, -- T
   {{{1, 1, 0, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},
   {{0, 0, 1, 0}, {0, 1, 1, 0}, {0, 1, 0, 0}, {0, 0, 0, 0}},
   {{0, 0, 0, 0}, {1, 1, 0, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}},
   {{0, 1, 0, 0}, {1, 1, 0, 0}, {1, 0, 0, 0}, {0, 0, 0, 0}}} -- Z
}

local block_colors = {
    {255, 179, 186}, -- red
    {255, 223, 186}, -- orange
    {255, 255, 186}, -- yellow
    {186, 255, 201}, -- green
    {186, 225, 255}, -- blue
    {186, 202, 255}, -- indygo
    {218, 186, 255} -- violet
}


function block.generate_block()
    if block.next_shape == nil then
        block.next_shape = shapes[math.random(1, #shapes)]
        block.next_color = block_colors[math.random(1, #block_colors)]
    end
    block.shape = block.next_shape
    block.color = block.next_color
    block.rotation = 1
    block.next_shape = shapes[math.random(1, #shapes)]
    block.next_color = block_colors[math.random(1, #block_colors)]
end

function block.place_block()
    block.x = math.floor(WIDTH / 2) - 2
    block.y = 1
end

function block.move_block_down()
    local collison = block.check_collision()
    if collison == false then
        block.y = block.y + 1
    else
        block.mark_block_on_board()
        local lines_cleared = board.remove_line()
        block.generate_block()
        block.place_block()
    end
end

function block.move_block_left()
    block.x = block.x - 1
    if block.check_collision() then
        block.x = block.x + 1 
    end
end

function block.move_block_right()
    block.x = block.x + 1
    if block.check_collision() then
        block.x = block.x - 1
    end
end

function block.rotate_block()
    local new_rotation = (block.rotation % 4) + 1
    if not block.check_collision(new_rotation) then
        block.rotation = new_rotation
    end
end

function block.check_collision(new_rotation)
    local rotation = new_rotation or block.rotation
    for i = 1, 4 do
        for j = 1, 4 do
            if block.shape[rotation][i][j] == 1 then
                local board_x = block.x + j - 1
                local board_y = block.y + i

                if board[board_y] and board[board_y][board_x] and
                (board[board_y][board_x] == "BLOCK" or (board[board_y][board_x] == "WALL" and board_y ~= 0)) then
                    return true
                end
            end
        end
    end
    return false
end

function block.mark_block_on_board()
    for i = 1, 4 do
        for j = 1, 4 do
            if block.shape[block.rotation][i][j] == 1 then
                local board_x = block.x + j - 1
                local board_y = block.y + i - 1
                board[board_y][board_x] = "BLOCK"
            end
        end
    end
end

return block