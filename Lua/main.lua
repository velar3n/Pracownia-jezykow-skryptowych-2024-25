_G.love = require("love")
block = require 'block'
board = require 'board'

-- grid parameters
WIDTH, HEIGHT, SIZE = 12, 25, 35
margin = WIDTH * SIZE

time = 0
update_speed = 0.5

function love.load() 
    math.randomseed(os.time())
    init()
end

function love.update(dt) 
    if state == "GAME" then
        time = time + dt
        if time > update_speed then
            block.move_block_down()
            check_game_over()
            time = 0
        end
    end
    if state == "LOST" then
        board.draw_game_over()
    end
end

function init()
    state = "GAME"
    board.set_fields()
    block.generate_block()
    block.place_block()
end 

function love.draw() 
    love.graphics.setBackgroundColor(love.math.colorFromBytes(BLACK))
    board.draw_sidebar()
    if state == "GAME" then
        board.draw_board()
    end
    if state == "LOST" then
        board.draw_game_over()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "a" and state == "GAME" then
        block.move_block_left()
    end
    if scancode == "d" and state == "GAME" then
        block.move_block_right()
    end
    if scancode == "space" and state == "GAME" then
        block.rotate_block()
    end
    if scancode == "s" and state == "GAME" then
        update_speed = 0.05
    end
end

function love.keyreleased(scancode)
    if scancode == "s" and state == "GAME" then
        update_speed = 0.5
    end
end

function check_game_over()
    for i = 1, WIDTH - 1 do
        if board[1][i] == "BLOCK" then
            state = "LOST"
        end
    end
end


