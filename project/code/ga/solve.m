function [bestsol,  bestfun] = solve(iterations = 100)
    global prevIndividuals individuals costs prevCosts f totaln genesize;

    nIndividuals = 20;
    nMutationSites = 2;
    pCrossover = 0.95;
    pMutation = 0.05;

    individuals = getRandomSolutions(nIndividuals);
    costs = zeros(1, nIndividuals);

    for i = 1:iterations
        prevCosts = costs;
        prevIndividuals = individuals;

        for j = 1 : nIndividuals
            ii = floor(nIndividuals * rand) + 1;
            jj = floor(nIndividuals * rand) + 1;

            if pCrossover > rand
                [individuals(ii,  : ), individuals(jj,  : )] = crossover(prevIndividuals(ii,  : ), prevIndividuals(jj,  : ));
                evolve(ii);
                evolve(jj);
            end

            if pMutation > rand
                kk = floor(nIndividuals * rand) + 1;
                individuals(kk, :) = mutate(prevIndividuals(kk,  :), nMutationSites);
                evolve(kk);
            end
        end

        [bestCost, bestIndex] = min(costs);
        bestIndividual = individuals(bestIndex);

        printIteration('ga', i, bestIndividual, bestCost);
    end
end

% Evolving the new generation
function evolve(j)
    global individuals costs prevCosts prevIndividuals;

    costs(j) = getSolutionCost(individuals(j,  : ));
    if costs(j) < prevCosts(j)
        prevIndividuals(j,  :) = individuals(j,  :);
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

    c(cPointLow : cPointHigh) = b(cPointLow : cPointHigh);
    d(cPointLow : cPointHigh) = a(cPointLow : cPointHigh);
    c = finishCrossover(c, b, cPointHigh, cPointLow);
    d = finishCrossover(d, a, cPointHigh, cPointLow);
end

function halfChild = finishCrossover(halfChild, parent, cPointHigh, cPointLow)
    childIndex = cPointHigh + 1;
    parentIndex = cPointHigh + 1;
    while childIndex ~= cPointLow
        if parentIndex > length(parent)
            parentIndex = parentIndex - length(parent);
        end
        if childIndex > length(parent)
            childIndex = childIndex - length(parent);
        end
        %If the child already has that value, just move on to the next index
        if ~isempty(find(halfChild == parent(parentIndex)))
            parentIndex = parentIndex + 1;
        else
            halfChild(childIndex) = parent(parentIndex);
            childIndex = childIndex + 1;
            parentIndex = parentIndex + 1;
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
