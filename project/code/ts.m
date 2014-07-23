function bestSolution = ts(iterations = 1000, tenure = 5)

  global nTasks tasks nRobots robots nHomes homes priorities skills distances

  solution = getRandomSolution();
  bestSolution = solution;
  bestSolutionCost = getSolutionCost(solution);

  tabu = zeros(size(solution));

  for i = 1:iterations
    neighbours = getSolutionNeighbours(solution, 10);

    nontabuNeighbours = neighbours(isNontabu(neighbours, solution, tabu), :);

    [bestNeighbour, bestNeighbourCost] = getBestSolution(neighbours);
    [bestNontabuNeighbour, bestNontabuNeighbourCost] = getBestSolution(nontabuNeighbours);

    if bestNontabuNeighbourCost < bestSolution
      nextSolution = bestNontabuNeighbour;

      bestSolution = bestNontabuNeighbour
      bestSolutionCost = bestNontabuNeighbourCost

    elseif bestNeighbourCost < bestSolutionCost
      nextSolution = bestNeighbour;

      bestSolution = bestNeighbour
      bestSolutionCost = bestNeighbourCost

    else
      nextSolution = bestNontabuNeighbour;

    endif

    tabu(tabu > 0) = tabu(tabu > 0) - 1;
    tabu(nextSolution != solution) += tenure;

  endfor

function isNontabu = isNontabu(neighbours, solution, tabu)
  isNontabu = ~isTabu(neighbours, solution, tabu);

function isTabu = isTabu(neighbours, solution, tabu)
  for i = 1:size(neighbours, 1)
    isTabu(i) = all(tabu(neighbours(i) ~= solution) == 0);
  endfor
