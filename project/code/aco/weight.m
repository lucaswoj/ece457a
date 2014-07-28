function v = weight(robot, src, dst)
    global homes priorities skills taskTimes distances velocities;

    v = 0.0000000001;
    if canMakeItHomeFrom(robot, src, dst)
        % figure out better way to import alpha
        alpha = 0.5;
        v = (1 - alpha) * (1 - priorities(dst)) * skills(robot, dst);
        v = v + getBeta() * alpha * energyCost(robot, src, dst);
    end

end

function isTrue = canMakeItHomeFrom(robot, src, dst)
    global homes energy;

    energyLeft = energy(robot);
    energyLeft = energyLeft - energyCost(robot, src, dst);

    if dst ~= homes(robot)
        % we can make it home from home, obvi
        energyLeft = energyLeft - energyCost(robot, dst, homes(robot));
    end

    isTrue = energyLeft >= 0;
end

