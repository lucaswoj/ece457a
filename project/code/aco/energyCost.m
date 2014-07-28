function cost = energyCost(robot, src, dst)
    global energy taskTimes distances velocities;

    cost = distances(src, dst)/velocities(robot) + taskTimes(robot, dst);
end

