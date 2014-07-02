% Genetic Algorithm (Simple Demo) Matlab/Octave Program
% Written by X S Yang (Cambridge University)
% Usage :  gasimple or gasimple('x * exp( - x)');
function [bestsol,  bestfun,  count] = gasimple(n)
    global solnew sol pop popnew fitness fitold f range totaln genesize;
    range = [ -1 1]; % Range/Domain

    % Converting to an inline function
    f = @func; 

    % Initializing the parameters
    rand('state' , 0'); % Reset the random generator
    popsize = 20; % Population size
    MaxGen = 100; % Max number of generations
    count = 0;    % counter
    nsite = 2;    % number of mutation sites
    pc = 0.95;    % Crossover probability
    pm = 0.05;    % Mutation probability
    genesize = 8;
    nsbit = genesize * n;   % String length (bits)
    totaln = n;

    % Generating the initial population
    popnew = init_gen(popsize, nsbit);
    fitness = zeros(1, popsize); % fitness array

    % Display the shape of the function
    x = range(1) : 0.1 : range(2); 

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

function y = func(geno)
    pheno = decode(geno);
    y = 0;
    for i = 1 : length(pheno),
        y = y + abs(pheno(i)) ^ (i + 1);
    end

    % want to minimize the function
    y = -y;

% All the sub functions
% generation of the initial population
function pop = init_gen(np, nsbit)
    pop = rand(np, nsbit) > 0.5;

% Evolving the new generation
function evolve(j)
    global solnew popnew fitness fitold pop sol f;
    solnew(j, :) = popnew(j,  : );
    fitness(j) = f(solnew(j, :));
    if fitness(j) > fitold(j), 
        pop(j,  : ) = popnew(j,  : );
        sol(j) = solnew(j);
    end

function pheno = decode(bin)
    global totaln genesize;

    pheno = [];

    for i = 1 : totaln,
        idx = 1 + (i - 1) * genesize;
        gene = bin(idx : idx + genesize - 1);
        pheno = [pheno bintodec(gene)];
    end

% Convert a binary string into a decimal number
function [dec] = bintodec(bin)
    global range;

    % Length of the string without sign
    nn = length(bin) - 1;
    num = bin(2 : end); % get the binary

    % Sign =  + 1 if bin(l) = 0; Sign =  - l if bin(l) = l.
    Sign = 1 - 2 * bin(1);
    dec = 0;

    % floating point/decimal place in a binary string
    dp = floor(log2(max(abs(range))));
    for i = 1 : nn, 
        dec = dec + num(i) * 2 ^ (dp - i);
    end

    dec = dec * Sign;

% Crossover operator
function [c, d] = crossover(a, b)
    nn = length(a) - 1;

    % generating a random crossover point
    cpoint = floor(nn * rand) + 1;
    c = [a(1 : cpoint) b(cpoint + 1 : end)];
    d = [b(1 : cpoint) a(cpoint + 1 : end)];

% Mutatation operator
function anew = mutate(a, nsite)
    nn = length(a); anew = a;
    for i = 1 : nsite, 
        j = floor(rand * nn) + 1;
        anew(j) = mod(a(j) + 1, 2);
    end

