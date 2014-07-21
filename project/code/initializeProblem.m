function initializeProblem()
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

    cost([1, 2, 0, 3])
end


function v = cost(solution)
    global homes;

    % append a sentinel to the end of the solution so the logic below works
    solution = [ solution, 0 ];

    v = 0;

    robot = 1;
    lastIndex = 1;
    for i = 1 : length(solution)
        % use 0 as a sentinal
        if solution(i) == 0
            path = [ homes(robot), solution(lastIndex : i - 1) ];

            v = v + costi(robot, path);
            lastIndex = i + 1;
            robot = robot + 1;
        end
    end
end


function v = weight(robot, src, dst)
    global homes priority skill distance;

    alpha = 1;
    beta = 1;
    gamma = 1;

    v = distance(src, dst);
    if dst == homes(robot)
        return;
    end

    v = v * (alpha - priority(dst)) ^ gamma;
    v = v * (beta - skill(robot, dst));
end


function v = costi(robot, path)
    global homes;

    v = weight(robot, path(end), homes(robot));
    for t = 1 : length(path) - 1
        v = v + weight(robot, path(t), path(t + 1));
    end
end

