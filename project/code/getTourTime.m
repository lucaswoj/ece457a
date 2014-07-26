function time = getTourTime(robot, tour)

    global nRobots velocities energy homes nTasks priorities skills taskTimes distances;

    taskTime = sum(times(robot, tour));

    distance = 0;
    for i=2:length(tour)
      distance = distance + distances(tour(i-1), tour(i));
    endfor
    travelTime = distance * velocities(robot);

    time = taskTime + travelTime;