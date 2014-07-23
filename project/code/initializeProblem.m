function initializeProblem(solution)
    global homes priority skill distance;

    homes = [ 4, 5 ];

    priority =  [
                    % first 3 are tasks
                    % last 2 are depots
                    0.1, 0.2, 0.3, 0, 0
                ];

    skill = [
                0.1, 0.4, 0.5;
                0.2, 0.3, 0.6
            ];

    distance =  [
                    0,   0.1, 0.2, 0.6, 0.5;
                    0.1, 0,   0.3, 0.3, 0.4;
                    0.2, 0.3, 0,   0.1, 0.2;
                    0.6, 0.3, 0.1, 0,   0;
                    0.5, 0.4, 0.2, 0,   0
                ];
end

