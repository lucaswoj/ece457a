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

