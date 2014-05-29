% Finds the best board for player with turn = 1
% With turn = -1, it will get THE WORST BOARD
function bestBoard = getBestBoard(board, turn, ab)
    bestBoard = board;
    bestScore = -Inf;

    if checkboard(board) ~= 0
        % there is a winrar -- nothing to do
        return;
    end

    for i = 1:9
        if board(i) ~= 0
            % Only permute squares that are empty
            continue;
        end
        
        evolution = board;
        evolution(i) = turn;

        % modify ab?
        score = scoreBoard(getBestBoard(evolution, -turn, ab)) * turn;

        if score > bestScore
            bestScore = score;
            bestBoard = evolution;
        end
    end

% stub function to test above
function score = scoreBoard(board)
    score = sum(board)

% stub
function win = checkboard(board)
    win = 0

