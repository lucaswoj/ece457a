function bestSolution = aco(iterations)
    initializeProblem();

    global homes;

    % construct the pheromone list
    numNodes = homes(end) - 1;
    numTasks = homes(1) - 1;
    tau = ones(numNodes + 1);

    alpha = 1;
    beta = 1;
    rho = 0.1;
    Q = 1; % pheromone amount

    bestSolution = [ ];
    bestDist = Inf;

    for i = 1 : iterations
        robot = 1;
        currentNode = homes(robot);
        visited = zeros(1, numNodes);

        path = [ ];
        distTraveled = 0;
        while sum(visited == 0) ~= 0
            neighbors = [ ];
            neighborWeight = [ ];
            for n = 1 : length(visited)
                if visited(n) == 0
                    if n > numTasks
                        % add the robot's depot as a neighbor
                        % and then return
                        neighbors = [ neighbors, homes(robot) ];
                        break;
                    else
                        neighbors = [ neighbors, n ];
                    end
                end
            end

            % compute neighbor weights
            for j = 1 : length(neighbors)
                n = neighbors(j);

                % add 1 to the denominator to avoid division by 0
                neighborWeight = [ neighborWeight, (weight(robot, currentNode, n)^beta + 1) ];
            end

            eta = 0;
            for j = 1 : length(neighbors)
                n = neighbors(j);
                eta = eta + tau(currentNode, n)^alpha / neighborWeight(j); 
            end

            eta

            cumlProb = [ ];
            for j = 1 : length(neighbors)
                n = neighbors(j);

                prob = tau(currentNode, n)^alpha / neighborWeight(j) / eta;
                cumlProb = [ cumlProb, prob ];
            end

            cumlProb
            selectedNeighbor = roulette(cumlProb)
            nextNode = neighbors(selectedNeighbor)
            distTraveled = distTraveled + neighborWeight(selectedNeighbor);

            visited(nextNode) = 1
            path = [ path, nextNode ]
            if nextNode == homes(robot)
                robot = robot + 1;

                try
                    nextNode = homes(robot);
                catch
                    % this only fails on the last iteration
                end
            end

            currentNode = nextNode;
        end

        if distTraveled < bestDist
            % transform depot nodes to sentinels
            bestSolution = path .* (path <= numTasks);
            bestDist = distTraveled;
        end

        augmentedPath = [ ]
        for j = 1 : length(path)
            augmentedPath = [ augmentedPath, path(j) ];
            if path(j) > numTasks
                augmentedPath = [ augmentedPath, path(j) + 1 ];
            end
        end
        path = [ homes(1), augmentedPath, homes(end) ];

        % update the pheromone
        tau = tau .* (1 - rho);
        for j = 1 : length(path) - 1
            tau(path(j), path(j + 1)) = tau(path(j), path(j + 1)) + Q / distTraveled;
            tau(path(j + 1), path(j)) = tau(path(j + 1), path(j)) + Q / distTraveled;
        end

        distTraveled
        tau
    end

    bestDist
end
