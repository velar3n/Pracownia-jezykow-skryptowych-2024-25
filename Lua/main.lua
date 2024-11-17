_G.love = require("love")
local block = require 'block'
local board = require 'board'

function love.load() 

end

function love.update(dt) 

end

function love.draw() 
    love.graphics.setBackgroundColor(love.math.colorFromBytes(BLACK))
    board.draw_board()
    board.draw_sidebar()
end
