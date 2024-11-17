_G.love = require("love")
local block = require 'block'
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
            time = 0
        end
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
    board.draw_board()
    board.draw_sidebar()
end

