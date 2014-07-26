function loadReducedProblem()

    global nRobots velocities energy homes nTasks priorities skills taskTimes distances;

    % TODO remove unnescessary globals (tasks, robots)
    % TODO turn on those assert statements


    nRobots = 2;
    nTasks = 3;

    velocities = [0.9146, 0.6509];
    energy = [58.2024, 45.0418];
    homes = (1:nRobots) + nTasks;

    priorities = [0.7761, 0.3663, 0.8863, 1, 1];

    skills = [
        0.97195, 0.46364, 0.83202, 1, 1;
        0.33896, 0.44659, 0.02791, 1, 1
    ];

    taskTimes = [
        0.25511, 0.88416, 0.61189, 0, 0;
        0.61632, 0.37353, 0.30623, 0, 0
    ];

    distances = [
        8.6779, 3.7604, 6.2783, 9.3271, 1.4957;
        8.0510, 3.3071, 8.4473, 1.3190, 4.9917;
        3.2972, 8.5977, 2.7686, 8.5270, 0.4359;
        2.5143, 8.4739, 4.6241, 0     , 0     ;
        1.2170, 6.1530, 3.9628, 0     , 0
    ];