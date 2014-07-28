function [bestsol,  bestfun] = solve(iterations = 100)
    global prevIndividuals individuals costs prevCosts nIndividuals nRobots nTasks;

    nIndividuals = 20;
    nMutationSites = 2;
    pCrossover = 0.95;
    pMutation = 0.05;

    individuals = getRandomSolutions(nIndividuals);
    costs = repmat(Inf, 1, nIndividuals);

    for i = 1:iterations
        count = 1;
        prevCosts = costs;
        prevIndividuals = individuals;

        for j = 1 : nIndividuals
            ii = floor(nIndividuals * rand) + 1;
            jj = floor(nIndividuals * rand) + 1;

            if pCrossover > rand
                [individuals(count,  : ), individuals(count + 1,  : )] = crossover(prevIndividuals(ii,  : ), prevIndividuals(jj,  : ));
                count = count + 2;
            end

            if pMutation > rand
                kk = floor(nIndividuals * rand) + 1;
                individuals(count, :) = mutate(prevIndividuals(kk,  :), nMutationSites);
                count = count + 1;
            end
        end

        individuals = chooseSurvivors(individuals, prevIndividuals);

        [bestCost, bestIndex] = min(costs);
        bestIndividual = individuals(bestIndex);

        printIteration('ga', i, bestIndividual, bestCost);
    end
end

% Evolving the new generation
function newGeneration = chooseSurvivors(children, parents)
    global costs prevCosts nIndividuals;


    newGeneration = [];
    generation = [children; , parents];
    [numRow, numVariables] = size(generation);
    for i = 1 : numRow
        genCosts(i) = getSolutionCost(generation(i, :));
    end

    for i = 1 : nIndividuals
        %find the best solution in the generation
        [bestCost, bestIndex] = min(genCosts);

        %add it to our cost vector and the output matrix
        costs(i) = bestCost;
        newGeneration(i, :) = generation(bestIndex, :);

        %Then remove the values from the generation
        generation(bestIndex, : ) = [];
        genCosts(bestIndex) = [];
    end

end

% Crossover operator, using the Order 1 crossover algorithm
function [c, d] = crossover(a, b)
    nn = length(a) - 1;

    % generating two random crossover points
    cPointHigh = floor(nn * rand) + 1;
    cPointLow = floor(nn * rand) + 1;

    %Order our crossover points
    if cPointLow > cPointHigh
        temp = cPointHigh;
        cPointHigh = cPointLow;
        cPointLow = temp;
    end

    c(cPointLow : cPointHigh) = a(cPointLow : cPointHigh);
    d(cPointLow : cPointHigh) = b(cPointLow : cPointHigh);
    c = finishCrossover(c, b, cPointHigh, cPointLow);
    d = finishCrossover(d, a, cPointHigh, cPointLow);
end

function halfChild = finishCrossover(halfChild, parent, cPointHigh, cPointLow)
    global nRobots;

    childIndex = cPointHigh + 1;
    parentIndex = cPointHigh + 1;
    while length(halfChild) ~= length(parent) || nnz(halfChild == 0) ~= nRobots - 1
        if parentIndex > length(parent),
            parentIndex = parentIndex - length(parent);
        end
        if childIndex > length(parent),
            childIndex = childIndex - length(parent);

        end
        %Check to see if we have a sentinal value
        if parent(parentIndex) == 0,
            %If our child does not have all of its sentinal values then we can insert one
            if nnz(halfChild == 0) < nRobots - 1,
                halfChild(childIndex) = parent(parentIndex);
                childIndex = childIndex + 1;
                parentIndex = parentIndex + 1;
            else
               parentIndex = parentIndex + 1;
            end
        else
            %If the child already has that value, just move on to the next index
            if ~isempty(find(halfChild == parent(parentIndex))),
                parentIndex = parentIndex + 1;
            else
                halfChild(childIndex) = parent(parentIndex);
                childIndex = childIndex + 1;
                parentIndex = parentIndex + 1;
            end
        end
    end
end

% Mutatation operator, doing a swap mutation
function anew = mutate(a)
    nn = length(a); anew = a;
    j = floor(rand * nn) + 1;
    k = floor(rand * nn) + 1;
    anew(j) = a(k);
    anew(k) = a(j);
end
