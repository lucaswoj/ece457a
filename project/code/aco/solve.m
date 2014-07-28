function bestSolution = solve(iterations)
    % initializeProblem();

    global homes;

    % construct the pheromone list
    numNodes = homes(end) - 1;
    numTasks = homes(1) - 1;
    tau = ones(numNodes + 1);

    alpha = 1;
    beta = 1;
    rho = 0.1;
    rnaught = 0.5;
    Q = 1; % pheromone amount

    bestSolution = [ ];
    bestDist = Inf;

    ants = cell(2,3)

    for i = 1 : iterations
        for ant = 1:length(ants)
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

                % Generate random number r, and compare to pre-chose r_o.
                % If r <= r_o then exploit most desirable path
                % Else explore path randomly selected using roulette wheel method

                % compute neighbor weights
                for j = 1 : length(neighbors)
                    n = neighbors(j);

                    % add 1 to the denominator to avoid division by 0
                    neighborWeight = [ neighborWeight, (weight(robot, currentNode, n, path)^beta + 1) ];
                end

                if rand <= rnaught
                    [maxWeight,selectedNeighbor] = max(neighborWeight); % getindex of most desirable neighbor
                    nextNode = neighbors(selectedNeighbor);
                else

                    eta = 0;
                    for j = 1 : length(neighbors)
                        n = neighbors(j);
                        eta = eta + tau(currentNode, n)^alpha * neighborWeight(j);
                    end

                    eta

                    cumlProb = [ ];
                    for j = 1 : length(neighbors)
                        n = neighbors(j);

                        prob = tau(currentNode, n)^alpha * neighborWeight(j) / eta;
                        cumlProb = [ cumlProb, prob ];
                    end

                    cumlProb
                    selectedNeighbor = roulette(cumlProb)
                    nextNode = neighbors(selectedNeighbor)
                end

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
            ants{ant, 1} = bestSolution
            ants{ant, 2} = bestDist
            ants{ant, 3} = augmentedPath
        end
        % determine ant with best solution:
        solutionCosts = 1:length(ants);
        for ant = 1:length(ants)
            solution = ants{ant, 1}
            solutionCosts(ant) = getSolutionCost(solution);
        end
        [cost, selectedAnt] = max(solutionCosts);
        path = ants{selectedAnt, 1}
        desirability = ants{selectedAnt, 2}
        augmentedPath = ants{selectedAnt, 3}

        % update the pheromone
        tau = tau .* (1 - rho);
        for j = 1 : length(augmentedPath) - 1
            j
            tau(augmentedPath(j), augmentedPath(j + 1)) = tau(augmentedPath(j), augmentedPath(j + 1)) + Q * desirability;
            tau(augmentedPath(j + 1), augmentedPath(j)) = tau(augmentedPath(j + 1), augmentedPath(j)) + Q * desirability;
        end

        desirability
        tau
    end

    bestDist
end
