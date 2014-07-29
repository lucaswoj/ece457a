function bestSolution = solve(iterations = 10)
    global homes energy homeConst;

    iterations = 1000;

    % construct the pheromone list
    numNodes = homes(end) - 1;
    numTasks = homes(1) - 1;

    tau = rand(numNodes + 1);

    bestAge = 0;
    maxAge = 50;

    exploitConst = 0.41;
    exploreConst = 1.15;
    rho = 0.76;
    rnaught = 0.43;
    numAnts = 3;
    Q = 1; % pheromone amount

    bestSolution = [ ];
    bestDist = Inf;

    totalEnergy = energy;
    ants = cell(numAnts, 2);

    for i = 1 : iterations
        bestAge;

        bestAge = bestAge + 1;
        if bestAge > maxAge
            bestSolution;
            bestDist;
            return
        end

        for ant = 1 : numAnts
            robot = 1;
            currentNode = homes(robot);
            visited = zeros(1, numNodes);

            path = [ ];
            desirability = 0;
            while sum(visited == 0) ~= 0
                neighbors = [ ];
                neighborWeight = [ ];
                neighborTauWeight = [ ];
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
                neighborWeight = 1 : length(neighbors);
                neighborTauWeight = 1 : length(neighbors);
                for j = 1 : length(neighbors)
                    n = neighbors(j);

                    neighborWeight(j) = weight(robot, currentNode, n)^exploreConst + 1;
                    neighborTauWeight(j) = neighborWeight(j) * tau(currentNode, n);
                end

                % Generate random number r, and compare to pre-chose r_o.
                % If r <= r_o then exploit most desirable path
                % Else explore path randomly selected using roulette wheel method
                if rand <= rnaught
                    [maxWeight, selectedNeighbor] = max(neighborTauWeight);
                    nextNode = neighbors(selectedNeighbor);
                else
                    eta = 0;
                    for j = 1 : length(neighbors)
                        n = neighbors(j);
                        eta = eta + tau(currentNode, n)^exploitConst * neighborWeight(j);
                    end

                    cumlProb = 1 : length(neighbors);
                    for j = 1 : length(neighbors)
                        n = neighbors(j);
                        cumlProb(j) = tau(currentNode, n)^exploitConst * neighborWeight(j) / eta;
                    end

                    selectedNeighbor = roulette(cumlProb);
                    nextNode = neighbors(selectedNeighbor);
                end

                visited(nextNode) = 1;
                path = [ path, nextNode ];
                desirability = desirability + neighborWeight(selectedNeighbor);
                energy(robot) = energy(robot) - energyCost(robot, currentNode, nextNode);

                if nextNode == homes(robot)
                    % teleport to a new robot if we've returned home
                    robot = robot + 1;

                    try
                        nextNode = homes(robot);
                    catch
                        % this only fails on the last iteration
                    end
                end

                currentNode = nextNode;
            end

            energy = totalEnergy;
            % get a canonical representation of the solution
            solution = path .* (path <= numTasks);
            cost = getSolutionCost(solution);

            if cost < bestDist
                bestSolution = solution;
                bestDist = cost;
                bestAge = 0;
            end

            augmentedPath = [ ];
            for j = 1 : length(path)
                augmentedPath = [ augmentedPath, path(j) ];
                if path(j) > numTasks
                    augmentedPath = [ augmentedPath, path(j) + 1 ];
                end
            end
            path = [ homes(1), augmentedPath, homes(end) ];

            ants{ant, 1} = cost;
            ants{ant, 2} = path;
        end

        % determine ant with best solution:
        solutionCosts = 1 : numAnts;
        for ant = 1 : numAnts
            solutionCosts(ant) = ants{ant, 1};
        end

        [cost, selectedAnt] = min(solutionCosts);
        path = ants{selectedAnt, 2};

        % update the pheromone
        tau = tau .* (1 - rho);
        for j = 1 : length(path) - 1
            tau(path(j), path(j + 1)) = tau(path(j), path(j + 1)) + Q / cost;
            %tau(path(j + 1), path(j)) = tau(path(j + 1), path(j)) + Q / cost;
        end

        printIteration('aco', i, bestSolution, bestDist);
    end

    bestSolution;
    bestDist;
end

