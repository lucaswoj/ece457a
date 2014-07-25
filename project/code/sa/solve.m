function bestSolution = solve()
	iterations = 100;
	initialTemperature = 100;
	minTemperature = 0.000001;
	coolingFactor = 0.8;

	global nTasks tasks nRobots robots nHomes homes priorities skills distances

	solution = getRandomSolution();
	solutionCost = getSolutionCost(solution);
	bestSolution = solution;
	bestSolutionCost = solutionCost;

	temperature = initialTemperature;
	i = 1;

	while temperature > minTemperature && i < iterations

		newSolution = getSolutionNeighbours(solution, 1);
		newSolutionCost = getSolutionCost(newSolution);

		if newSolutionCost < solutionCost || exp(1)^((solutionCost - newSolutionCost)/temperature) > rand()
			solution = newSolution;
			solutionCost = newSolutionCost;
		end

		if solutionCost < bestSolutionCost
			bestSolution = solution;
			bestSolutionCost = solutionCost;
		end

		temperature = temperature * coolingFactor;
	end

end