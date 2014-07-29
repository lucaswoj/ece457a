function bestSolution = solve()
	% best values
	% small: 4.389394
	% medium: 5.701371
	% large: 18.648358

	global nTasks

	% small
	geometricCooling = true;
	if nTasks > 5 && nTasks <= 15 % medium
		geometricCooling = true;
	elseif nTasks > 15 % large
		geometricCooling = true;
	end

	if geometricCooling
		% small
		initialTemperature = 13;		% Starting temperature (better to be too high than too low)
		if nTasks > 5 && nTasks <= 15 % medium
			initialTemperature = 15;
		elseif nTasks > 15 % large
			initialTemperature = 12;
		endif

		% small
		minTemperature = 0.1;			% Terminate after reaching this temperature
		if nTasks > 5 && nTasks <= 15 % medium
			minTemperature = 0.0002;
		elseif nTasks > 15 % large
			minTemperature = 0.00001;
		end

		% small
		coolingFactor = 0.85;			% (0, 1), typically between 0.7 and 0.95. Higher = slower cooling
		if nTasks > 5 && nTasks <= 15 % medium
			coolingFactor = 0.93;
		elseif nTasks > 15 % large
			coolingFactor = 0.93;
		end
		
		% small
		iterationsPerTemperature = 80;	% Decrease temperature every X iterations
		if nTasks > 5 && nTasks <= 15 % medium
			iterationsPerTemperature = 150;
		elseif nTasks > 15 % large
			iterationsPerTemperature = 250;
		end
	else
		% small
		initialTemperature = 13;		% Starting temperature (better to be too high than too low)
		if nTasks > 5 && nTasks <= 15 % medium
			initialTemperature = 15;
		elseif nTasks > 15 % large
			initialTemperature = 15;
		end

		% small
		minTemperature = 0.01;			% Terminate after reaching this temperature
		if nTasks > 5 && nTasks <= 15 % medium
			minTemperature = 0.1;
		elseif nTasks > 15 % large
			minTemperature = 0.1;
		end

		% small
		coolingFactor = 0.01;			% (0, 1), Higher = faster cooling
		if nTasks > 5 && nTasks <= 15 % medium
			coolingFactor = 0.1;
		elseif nTasks > 15 % large
			coolingFactor = 0.1;
		end
		
		% small
		iterationsPerTemperature = 3;	% Decrease temperature every X iterations
		if nTasks > 5 && nTasks <= 15 % medium
			iterationsPerTemperature = 100;
		elseif nTasks > 15 % large
			iterationsPerTemperature = 100;
		end
	end

	solution = getRandomSolutions(1);
	solutionCost = getSolutionCost(solution);
	bestSolution = solution;
	bestSolutionCost = solutionCost;

	temperature = initialTemperature;
	i = 1;

	while temperature > minTemperature

		newSolution = getSolutionNeighbours(solution, 1);
		newSolutionCost = getSolutionCost(newSolution);
		if newSolutionCost < solutionCost || exp((solutionCost - newSolutionCost) / temperature) > rand()
			solution = newSolution;
			solutionCost = newSolutionCost;
		end

		if solutionCost < bestSolutionCost
			bestSolution = solution;
			bestSolutionCost = solutionCost;
		end

		if mod(i, iterationsPerTemperature) == 0
			if (geometricCooling)
				temperature = temperature * coolingFactor;
			else
				temperature = temperature - coolingFactor;
			end
		end

		printIteration('sa', i, bestSolution, bestSolutionCost);

		i = i + 1;
	end

end
