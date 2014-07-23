function loadReducedProblem()

    global nTasks tasks nRobots robots nHomes homes priorities skills distances;

    nTasks = 3;
    tasks = 1:nTasks;

    nRobots = 2;
    robots = 1:nRobots;

    nHomes = nRobots;
    homes = (1:nRobots) + nTasks;

    priorities =  [0.1, 0.2, 0.3, 0, 0];
    % assert(size(priorities) == [nTasks])

    skills = [
        0.1, 0.4, 0.5, 0, 0;
        0.2, 0.3, 0.6, 0, 0
    ];
    % assert(size(priorities) == [nTasks, nRobots])

    distances =  [
        0,   0.1, 0.2, 0.6, 0.5;
        0.1, 0,   0.3, 0.3, 0.4;
        0.2, 0.3, 0,   0.1, 0.2;
        0.6, 0.3, 0.1, 0,   0;
        0.5, 0.4, 0.2, 0,   0
    ];
    % assert(size(priorities) == [nTasks + nHomes, nRobots + nHomes])