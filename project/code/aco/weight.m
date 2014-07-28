function v = weight(robot, src, dst, curPath)
    global homes priorities skills taskTimes distances velocities;

    % alpha = 1;
    % beta = 1;
    % gamma = 1;

    % v = distance(src, dst);
    % if dst == homes(robot)
    %     return;
    % end

    % v = v * (alpha - priority(dst)) ^ gamma;
    % v = v * (beta - skill(robot, dst));

    % determine which case we're in

    if dst == homes(robot)
        v = 0.5
    elseif canMakeItHomeFrom(dst, curPath, robot, dst)
        % figure out better way to import alpha and beta
        alpha = 0.5;
        v = (1-alpha)*(1-priorities(dst))*skills(robot,dst);
        v = v + getBeta()*alpha*( (distances(src,dst))/velocities(robot) + taskTimes(robot, dst) )
    else
        v = 0.0000000001
        % v = -Inf
    end

end

function isTrue = canMakeItHomeFrom(node, curPath, robot, dst)
    global homes energy taskTimes distances velocities;

    energyLeft = energy(robot);
    curPath = [curPath, dst];

    % need to determine energy expended so far
    for i = length(curPath):-1:2
        if curPath(i) >= homes(1) % if we encounter ANY home node, then stop
            break
        else
            energyLeft = energyLeft - (taskTimes(i) + distances(curPath(i-1), curPath(i)));
        end
    end

    % return true if there will be enough energy to make it home from dst
    isTrue = (energyLeft >= ((distances(dst, homes(robot)))/velocities(robot)))
end

