function cost = getSolutionCost(solution)

    global nTasks tasks nRobots robots nHomes homes priorities skills distances

    cost = 0;
    solution = [0, solution, 0];

    solution;
    homeIndicies = find(solution == 0);
    assert(length(homeIndicies) == nRobots + 1);

    for robot = 1:nRobots

        % Extract one path (home -> home) from the overall solution
        solutionIndicies = homeIndicies(robot):homeIndicies(robot + 1);
        path = solution(solutionIndicies);

        % Replace the first and last sentinal values with this robot's home
        path([1, length(path)]) = homes([robot, robot]);

        cost = cost + getPathCost(path, robot);

    endfor

function cost = getPathCost(path, robot)
    SKILL_PRIORITY_WEIGHT = 0.5;
    DISTANCE_WEIGHT = 1 - SKILL_PRIORITY_WEIGHT;
    assert(SKILL_PRIORITY_WEIGHT + DISTANCE_WEIGHT == 1)

    cost = 0;

    for i = 1:length(path)
        cost = cost + SKILL_PRIORITY_WEIGHT * getSkillPriorityCost(robot, path(i));
    endfor

    for i = 1:(length(path) - 1)
        cost = cost + DISTANCE_WEIGHT * getDistanceCost(robot, path(i), path(i + 1));
    endfor

function cost = getDistanceCost(robot, from, to)
    global distances;
    cost = distances(from, to);

function cost = getSkillPriorityCost(robot, task)
    global skills priorities;

    % TODO should this be 1 - skill * priority instead?
    cost = 1 - skills(robot, task) * priorities(task);
