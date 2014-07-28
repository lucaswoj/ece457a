function bestSolution = solve(iterations)
    % initializeProblem();

    global homes energy;

    % construct the pheromone list
    numNodes = homes(end) - 1;
    numTasks = homes(1) - 1;
    tau = ones(numNodes + 1);

    exploitConst = 1;
    exploreConst = 1;
    rho = 0.1;
    rnaught = 0.5;
    Q = 1; % pheromone amount

    bestSolution = [ ];
    mostDesired = -Inf;

    totalEnergy = energy
    ants = cell(2,3)

    for i = 1 : iterations
        for ant = 1:length(ants)
            energy = totalEnergy

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
                neighborWeight = 1 : length(neighbors)
                neighborTauWeight = 1 : length(neighbors)
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

                    eta

                    cumlProb = 1 : length(neighbors);
                    for j = 1 : length(neighbors)
                        n = neighbors(j);
                        cumlProb(j) = tau(currentNode, n)^exploitConst * neighborWeight(j) / eta;
                    end

                    cumlProb
                    selectedNeighbor = roulette(cumlProb)
                    nextNode = neighbors(selectedNeighbor)
                end

                visited(nextNode) = 1
                path = [ path, nextNode ]
                desirability = desirability + neighborWeight(selectedNeighbor);
                energy(robot) = energy(robot) - energyCost(robot, currentNode, nextNode)

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

            % get a canonical representation of the solution
            solution = path .* (path <= numTasks);

            if desirability > mostDesired
                bestSolution = solution; 
                mostDesired = desirability;
            end

            augmentedPath = [ ]
            for j = 1 : length(path)
                augmentedPath = [ augmentedPath, path(j) ];
                if path(j) > numTasks
                    augmentedPath = [ augmentedPath, path(j) + 1 ];
                end
            end
            path = [ homes(1), augmentedPath, homes(end) ];

            ants{ant, 1} = getSolutionCost(solution)
            ants{ant, 2} = desirability
            ants{ant, 3} = path
        end

        % determine ant with best solution:
        solutionCosts = 1 : length(ants);
        for ant = 1 : length(ants)
            solutionCosts(ant) = ants{ant, 1};
        end

        [cost, selectedAnt] = max(solutionCosts);
        desirability = ants{selectedAnt, 2};
        path = ants{selectedAnt, 3};

        % update the pheromone
        tau = tau .* (1 - rho);
        for j = 1 : length(path) - 1
            tau(path(j), path(j + 1)) = tau(path(j), path(j + 1)) + Q * desirability;
            tau(path(j + 1), path(j)) = tau(path(j + 1), path(j)) + Q * desirability;
        end

        desirability
        tau
    end

    mostDesired
end

