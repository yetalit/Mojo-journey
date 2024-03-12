from python import Python
from collections.vector import InlinedFixedVector

# Global variables are introduced in version 24.1
var play: Bool = True
var turn: StringLiteral = "X"

fn computerMove(inout board: InlinedFixedVector[StringLiteral], borrowed pSymbol: StringLiteral) raises:
    var bestScore: Int = -10
    var bestMove: Int = 0

    for i in range(9):
        if board[i] == " ":
            board[i] = turn
            var score: Int = miniMax(board, pSymbol, False)
            board[i] = " "

            if score > bestScore:
                bestScore = score
                bestMove = i

    insertValue(board, bestMove)


fn miniMax(owned board: InlinedFixedVector[StringLiteral], borrowed pSymbol: StringLiteral, borrowed maximizing: Bool) raises -> Int:
    if checkForWin(board, turn):
        return 1

    elif checkForWin(board, pSymbol):
        return -1

    elif checkForDraw(board):
        return 0

    if maximizing:
        var bestScore: Int = -10

        for i in range(9):
            if board[i] == " ":
                board[i] = turn
                var score: Int = miniMax(board, pSymbol, False)
                board[i] = " "

                if score > bestScore:
                    bestScore = score

        return bestScore

    else:
        var bestScore: Int = 10

        for i in range(9):
            if board[i] == " ":
                board[i] = pSymbol
                var score: Int = miniMax(board, pSymbol, True)
                board[i] = " "

                if score < bestScore:
                    bestScore = score

        return bestScore


fn displayBoard(borrowed board: InlinedFixedVector[StringLiteral]) raises:
    print(str(board[0]) + "|" + str(board[1]) + "|" + str(board[2]))
    print("-+-+-")
    print(str(board[3]) + "|" + str(board[4]) + "|" + str(board[5]))
    print("-+-+-")
    print(str(board[6]) + "|" + str(board[7]) + "|" + str(board[8]))
    print('---------------------------------------')


fn insertValue(inout board: InlinedFixedVector[StringLiteral], borrowed position: Int) raises:
    if board[position] == " ":
        board[position] = turn

        if checkForWin(board, turn):
            displayBoard(board)
            print(turn, "has won the game.")
            play = False

        if checkForDraw(board):
            displayBoard(board)
            print("This game is a draw.")
            play = False

        if turn == "X":
            turn = "O"

        else:
            turn = "X"

    else:
        print("Error: position is already occupied.")


fn checkForDraw(owned board: InlinedFixedVector[StringLiteral]) -> Bool:
    for i in range(9):
        if board[i] == " ":
            return False

    return True


fn checkForWin(borrowed board: InlinedFixedVector[StringLiteral], borrowed cPlayer: StringLiteral) raises -> Bool:
    # horizontal 1
    if board[0] == board[1] and board[1] == board[2] and board[2] == cPlayer:
        return True

    # horizontal 2
    if board[3] == board[4] and board[4] == board[5] and board[5] == cPlayer:
        return True

    # horizontal 3
    elif board[6] == board[7] and board[7] == board[8] and board[8] == cPlayer:
        return True

    # vertical 1
    elif board[0] == board[3] and board[3] == board[6] and board[6] == cPlayer:
        return True

    # vertical 2
    elif board[1] == board[4] and board[4] == board[7] and board[7] == cPlayer:
        return True

    # vertical 3
    elif board[2] == board[5] and board[5] == board[8] and board[8] == cPlayer:
        return True

    # diagonal 1
    elif board[0] == board[4] and board[4] == board[8] and board[8] == cPlayer:
        return True

    # diagonal 2
    elif board[2] == board[4] and board[4] == board[6] and board[6] == cPlayer:
        return True

    # no win
    else:
        return False

fn main():
    play = True
    # X starts first
    turn = "X"
    var board = InlinedFixedVector[StringLiteral](9)
    for i in range(9):
        board[i] = " "
    random.seed()  # Seed to generate random numbers each time
    # Player's symbol
    var pSymbol: StringLiteral = "O" if random.random_ui64(0, 1) else "X"  # Randomly choose the first player (0:X, 1:O)
    var firstMove: UInt64 = 0

    try:
        var py = Python.import_module('builtins')

        displayBoard(board)

        while play:
            if turn != pSymbol:
                # AI's turn
                if firstMove == 10:
                    computerMove(board, pSymbol)
                else:
                    # AI randomly moves for its first turn (to give the human player a chance to win)
                    var rand: UInt64 = firstMove
                    while rand == firstMove:
                        rand = random.random_ui64(1, 9)  # Generate an unsigned random number between 1 to 9
                    insertValue(board, rand.to_int() - 1)
                    firstMove = 10
                displayBoard(board)
            else:
                # Player's turn
                try:
                    # Convert user input to String then to int
                    var position: Int = atol(str(py.input("Enter the position to place " + str(turn) + ": ")))
                    if position >= 1 and position <= 9:
                        if firstMove == 0:
                            firstMove = position
                        insertValue(board, position - 1)
                        displayBoard(board)
                    else:
                        print("Enter a number between 1 to 9...")
                except:
                    print("Please Enter a number...")
    except:
        print('Error importing modules!')