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

function v = costi(robot, path)
    global homes;

    v = weight(robot, path(end), homes(robot));
    for t = 1 : length(path) - 1
        v = v + weight(robot, path(t), path(t + 1));
    end
end

