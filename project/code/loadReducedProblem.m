function loadReducedProblem()

    global nTasks tasks nRobots robots nHomes homes velocities priorities skills distances;

    % TODO remove unnescessary globals (tasks, robots)
    % TODO turn on those assert statements

    nTasks = 3;
    tasks = 1:nTasks;

    nRobots = 2;
    robots = 1:nRobots;

    velocities = [1, 2];

    times = [
        1, 4, 5, 0, 0;
        2, 3, 6, 0, 0
    ];

    nHomes = nRobots;
    homes = (1:nRobots) + nTasks;

    priorities = [0.1, 0.2, 0.3, 1, 1];
    % assert(size(priorities) == [nTasks])

    skills = [
        0.1, 0.4, 0.5, 1, 1;
        0.2, 0.3, 0.6, 1, 1
    ];
    % assert(size(priorities) == [nTasks, nRobots])

    distances =  [
        0, 1, 2, 6, 5;
        1, 0, 3, 3, 4;
        2, 3, 0, 1, 2;
        6, 3, 1, 0, 0;
        5, 4, 2, 0, 0
    ];
    % assert(size(priorities) == [nTasks + nHomes, nRobots + nHomes])