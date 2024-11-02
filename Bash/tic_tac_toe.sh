# Natalia Kiełbasa - Pracownia języków skryptowych 2024/25 - projekt Bash - kółko krzyżyk

#!/bin/bash

# File with saved game
save_file="tic_tac_toe_save.txt"

# Initialize the board with empty spaces
declare -A board
for row in {1..3}; do
    for col in {1..3}; do
        board["$row,$col"]=" "
    done
done

# Display the board
print_board() {
    echo ""
    echo "            X   Y   Z"
    echo ""
    for row in {1..3}; do
        echo -n "    $row       ${board["$row,1"]} | ${board["$row,2"]} | ${board["$row,3"]}"
        if [[ $row -lt 3 ]]; then
            echo -e "\n          ----+---+----"
        else
            echo ""
        fi
    done
    echo ""
}

# Save the current game state to a file
save_game() {
    echo "$game_mode" > "$save_file"
    echo "$moves" >> "$save_file"
    for row in {1..3}; do
        for col in {1..3}; do
            echo -n "${board["$row,$col"]}" >> "$save_file"
        done
        echo "" >> "$save_file"
    done
    echo "Game saved!"
}

# Load the game state from a file
load_game() {
    echo ""
    if [[ ! -f "$save_file" ]]; then
        echo "No saved game found."
        initialize_board
        return
    fi

    # Read game mode and moves
    local line row
    mapfile -t lines < "$save_file"
    game_mode="${lines[0]}"
    moves="${lines[1]}"
    for row in {1..3}; do
        local line="${lines[$((row+1))]}"
        board["$row,1"]="${line:0:1}"
        board["$row,2"]="${line:1:1}"
        board["$row,3"]="${line:2:1}"
    done
    echo "Game loaded successfully!"
    case "$game_mode" in
        1) echo "Game mode: Player vs Player";;
        2) echo "Game mode: Player vs Computer";;
    esac
}

# Check if the current board has a winning combination
is_winning() {
    # Rows, columns, and diagonals
    for i in {1..3}; do
        if [[ "${board["$i,1"]}" != " " && "${board["$i,1"]}" == "${board["$i,2"]}" && "${board["$i,2"]}" == "${board["$i,3"]}" ]] || 
           [[ "${board["1,$i"]}" != " " && "${board["1,$i"]}" == "${board["2,$i"]}" && "${board["2,$i"]}" == "${board["3,$i"]}" ]]; then
            return 0
        fi
    done
    if [[ "${board["1,1"]}" != " " && "${board["1,1"]}" == "${board["2,2"]}" && "${board["2,2"]}" == "${board["3,3"]}" ]] || 
       [[ "${board["1,3"]}" != " " && "${board["1,3"]}" == "${board["2,2"]}" && "${board["2,2"]}" == "${board["3,1"]}" ]]; then
        return 0
    fi
    return 1
}

# Player move
player_move() {
    local symbol="$1"
    local row col valid_move=0
    while [[ $valid_move -eq 0 ]]; do
        echo -n "Player ($symbol), enter your move (row, column --> e.g., '1Z'): "
        read -r input
        row=${input:0:1}
        col=${input:1:1}

        case $col in
            x|X) col=1 ;;
            y|Y) col=2 ;;
            z|Z) col=3 ;;
            *) col=0 ;;  # Invalid column input
        esac

        if [[ $row -ge 1 && $row -le 3 && $col -ge 1 && $col -le 3 && "${board["$row,$col"]}" == " " ]]; then
            board["$row,$col"]="$symbol"
            valid_move=1
        else
            echo "Invalid move. Please try again."
        fi
    done
}

# Computer move
computer_move() {
    local row col found_move=0
    local -a empty_cells
    for row in {1..3}; do
        for col in {1..3}; do
            if [[ "${board["$row,$col"]}" == " " ]]; then
                empty_cells+=("$row,$col")
            fi
        done
    done

    # Check if the computer can win on his next move
    for cell in "${empty_cells[@]}"; do
        IFS=',' read -r row col <<< "$cell"
        board["$row,$col"]="O"
        if is_winning; then
            return
        else
            board["$row,$col"]=" "
        fi
    done

    # Check if the computer can block the player from winning on his next move -> defense
    for cell in "${empty_cells[@]}"; do
        IFS=',' read -r row col <<< "$cell"
        board["$row,$col"]="X"
        if is_winning; then
            board["$row,$col"]="O"
            return
        else
            board["$row,$col"]=" "
        fi
    done

    # Random choice if no blocking or winning move is found
    IFS=',' read -r row col <<< "${empty_cells[$((RANDOM % ${#empty_cells[@]}))]}"
    board["$row,$col"]="O"
}

# Game main loop
echo " ----------- TIC-TAC-TOE GAME ----------- "
echo "Instructions: Enter your moves by row and column (e.g., '1Z')."
echo "Goal: Align three of your 'X' symbols vertically, horizontally, or diagonally."

# Menu
while [[ $game_mode -eq 0 ]]; do
    echo "Choose an option:"
    echo "1. Player vs Player"
    echo "2. Player vs Computer"
    echo "3. Load saved game"
    echo "4. Exit"
    read -r choice
    case $choice in
        1) game_mode=1 ;;
        2) game_mode=2 ;;
        3) load_game ;;
        4) echo "Exiting game."; exit ;;
        *) echo "Invalid option. Please select 1, 2, 3, or 4." ;;
    esac
done

moves=0
while [[ $moves -lt 9 ]]; do
    print_board
    save_game
    if [[ $game_mode -eq 1 ]]; then
        if (( moves % 2 == 0 )); then
            player_move "X"
        else
            player_move "O"
        fi
    else
        player_move "X"
        ((moves++))
        if is_winning; then
            print_board
            echo "CONGRATULATIONS! YOU WON!"
            rm -f "$save_file"
            exit
        fi
        [[ $moves -ge 9 ]] && break
        computer_move
    fi
    ((moves++))
    if is_winning; then
        print_board
        if [[ $game_mode -eq 1 ]]; then
            echo "PLAYER $([[ $((moves % 2)) -eq 1 ]] && echo X || echo O) WINS!"
        else
            echo "YOU LOST TO THE COMPUTER!"
        fi
        rm -f "$save_file"
        exit
    fi
done

print_board
echo "It's a TIE!"
rm -f "$save_file"

