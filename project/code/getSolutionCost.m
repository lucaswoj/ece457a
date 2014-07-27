function cost = getSolutionCost(solution, alpha = 0.5)

    global nRobots velocities energy homes nTasks priorities skills taskTimes distances;

    costEnergy = 0;
    costTime = 0;
    costQuality = 0;

    solution = [0, solution, 0];

    homeIndicies = find(solution == 0);
    assert(length(homeIndicies) == nRobots + 1);

    for robot = 1:nRobots

        % Extract one path (home -> home) from the overall solution
        solutionIndicies = homeIndicies(robot):homeIndicies(robot + 1);
        tour = solution(solutionIndicies);

        % Replace the first and last sentinal values with this robot's home
        tour([1, length(tour)]) = homes([robot, robot]);

        tourTime = getTourTime(robot, tour);

        costTime = max(costTime, tourTime);
        costQuality = costQuality + sum(skills(robot, tour) .* priorities(tour));
        if tourTime > energy(robot)
            costEnergy = Inf;
        endif
    endfor

    cost = costEnergy + alpha * getBeta() * costTime + (1 - alpha) * costQuality;


