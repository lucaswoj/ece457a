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

		while true
			newSolution = getSolutionNeighbours(solution, 1);
			newSolutionCost = getSolutionCost(newSolution);

			if newSolutionCost < solutionCost
				solution = newSolution;
				solutionCost = newSolutionCost;
				break
			end

			p = exp(1)^((solutionCost - newSolutionCost)/temperature);
			if (rand() < p)
				solution = newSolution;
				solutionCost = newSolutionCost;
				break
			end
		end

		if solutionCost < bestSolutionCost
			bestSolution = solution;
			bestSolutionCost = solutionCost;
		end

		temperature = temperature * coolingFactor;
	end

end