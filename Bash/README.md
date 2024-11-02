# Tic Tac Toe - Bash Script Game

## Author: Natalia Kiełbasa

This is a game of tic-tac-toe implemented as a command-line game in Bash. This game allows you to play the game in two modes: 
Player vs. Player or Player vs. Computer. 
In case you can't finish your game - it will be saved automatically, load it later to resume the unfinished game.

## Set it up
This script runs in a Bash environment:
1. Save 'tic_tac_toe.sh' locally
2. Run the game: 
```bash
./tic_tac_toe.sh
```

## How to win
The objective is to get three of your symbols in a row, either horizontally, vertically, or diagonally. The game will announce if there’s a winner or if it ends in a draw.

## How to play
1. Run the script
2. Choose a mode:
    * 1 for Player vs Player
    * 2 for Player vs Computer
    * 3 to Load a Saved Game
    * 4 to Exit
3. If you chose one of modes 1-3 you will be asked to make a move. The game board is displayed with rows and columns labeled. Choose a row (1-3) and column (X, Y, Z) to place your mark. For example, to place a mark on the top right cell, input 1Z.

## Saving and loading the game
The game automatically saves your progress when you choose to exit. You can load a saved game by selecting option 3 at the start. The game will restore the board, game mode, and turn count as they were.
