function beta = getBeta()

    global nRobots velocities energy homes nTasks priorities skills taskTimes distances;

    [maxDistance, _] = max(distances(:));
    [maxVelocity, _] = min(velocities);
    [maxTaskTime, _] = max(taskTimes(:));

    maxTravelTime = maxDistance / maxVelocity;

    [maxTime, _] = max([maxTravelTime, maxTaskTime]);

    beta = nRobots / 2 / maxTime;