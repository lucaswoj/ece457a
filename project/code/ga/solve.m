%CODE TAKEN FROM SAMPLE ON ASSIGNMENT
% Genetic Algorithm (Simple Demo) Matlab/Octave Program
% Written by X S Yang (Cambridge University)



function [bestsol,  bestfun,  count] = solve()
    global solnew sol pop popnew fitness fitold f range totaln genesize;
    range = [ -1 1]; % Range/Domain

    % Converting to an inline function
    %f = @func; 

    % Initializing the parameters
    rand('state' , 0'); % Reset the random generator
    popsize = 20; % Population size
    MaxGen = 100; % Max number of generations
    count = 0;    % counter
    nsite = 2;    % number of mutation sites
    pc = 0.95;    % Crossover probability
    pm = 0.05;    % Mutation probability

    % Generating the initial population
    popnew = init_gen(popsize);
    fitness = zeros(1, popsize); % fitness array

    % Initialize solution < -  initial population
    for i = 1 : popsize, 
        solnew(i, :) = popnew(i,  : );
    end

    % Start the evolution loop
    for i = 1 : MaxGen, 
        % Record as the history
        fitold = fitness; pop = popnew; sol = solnew;
        for j = 1 : popsize, 
            % Crossover pair
            ii = floor(popsize * rand) + 1; jj = floor(popsize * rand) + 1;

            % Cross over
            if pc > rand, 
                [popnew(ii,  : ), popnew(jj,  : )] = crossover(pop(ii,  : ), pop(jj,  : ));
                % Evaluate the new pairs
                count = count + 2;
                evolve(ii); evolve(jj);
            end

            % Mutation at n sites
            if pm > rand, 
                kk = floor(popsize * rand) + 1; count = count + 1;
                popnew(kk,  : ) = mutate(pop(kk,  : ), nsite);
                evolve(kk);
            end
        end % end for j

        % Record the current best
        bestfun(i) = max(fitness);
        bestsol(i) = mean(sol(bestfun(i) == fitness));
    end

    % Display results
    set(gcf, 'color', 'w');
    subplot (2, 1, 1); plot(bestsol); title('Best estimates');
    subplot(2, 1, 2); plot(bestfun); title('Fitness');
    bestsol(MaxGen)
end


% All the sub functions
% generation of the initial population
function pop = init_gen(numPopulation)
    for i = 1:numPopulation,
        solution = getRandomSolution();
        pop(i,:) = solution;
    end
end


% Evolving the new generation
function evolve(j)
    global solnew popnew fitness fitold pop sol;
    solnew(j, :) = popnew(j,  : );
    fitness(j) = getSolutionCost(solnew(j, :));
    if fitness(j) > fitold(j), 
        pop(j,  : ) = popnew(j,  : );
        sol(j) = solnew(j);
    end
end

% Crossover operator, using the Order 1 crossover algorithm
function [c, d] = crossover(a, b)
    nn = length(a) - 1;

    % generating two random crossover points
    cPointHigh = floor(nn * rand) + 1;
    cPointLow = floor(nn * rand) + 1;

    %Order our crossover points
    if cPointLow > cPointHigh,
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
    while childIndex ~= cPointLow,
        if parentIndex > length(parent)
            parentIndex = parentIndex - length(parent);
        end
        if childIndex > length(parent)
            childIndex = childIndex - length(parent);
        end
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

% Mutatation operator, doing a swap mutation
function anew = mutate(a)
    nn = length(a); anew = a;
    j = floor(rand * nn) + 1; 
    k = floor(rand * nn) + 1;
    anew(j) = a(k);
    anew(k) = a(j);
end
