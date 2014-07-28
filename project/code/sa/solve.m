function bestSolution = solve()
	iterations = 10000;				% Max # of iterations
	initialTemperature = 1000;		% Starting temperature (better to be too high than too low)
	minTemperature = 0.01;			% Terminate after reaching this temperature
	coolingFactor = 0.85;			% (0, 1), typically between 0.7 and 0.95. Higher = slower cooling
	iterationsPerTemperature = 3;	% Decrease temperature every X iterations

	solution = getRandomSolutions(1);
	solutionCost = getSolutionCost(solution);
	bestSolution = solution;
	bestSolutionCost = solutionCost;

	temperature = initialTemperature;
	i = 1;

	while temperature > minTemperature && i < iterations

		newSolution = getSolutionNeighbours(solution, 1);
		newSolutionCost = getSolutionCost(newSolution);

		if newSolutionCost < solutionCost || exp(1)^((solutionCost - newSolutionCost) / temperature) > rand()
			solution = newSolution;
			solutionCost = newSolutionCost;
		end

		if solutionCost < bestSolutionCost
			bestSolution = solution;
			bestSolutionCost = solutionCost;
		end

		if mod(i, iterationsPerTemperature) == 0
			temperature = temperature * coolingFactor;
		end

		printIteration('sa', i, bestSolution, bestSolutionCost);

		i = i + 1;
	end

end
