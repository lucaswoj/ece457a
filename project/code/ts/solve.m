function [bestSolution, bestSolutionCost] = solve(iterations)

  global nTasks tasks nRobots robots nHomes homes priorities skills distances

  if nTasks == 50
    tenure = 120;
    bestSolutionAgeMax = 3000;

  elseif nTasks == 15
    tenure = 10;
    bestSolutionAgeMax = 1500;

  elseif nTasks == 5
    tenure = 5;
    bestSolutionAgeMax = 1000;

  elseif nTasks == 3
    tenure = 5;
    bestSolutionAgeMax = 1000;

  else
    assert(false)
  endif

  solution = getRandomSolutions(1);
  bestSolution = solution;
  bestSolutionCost = getSolutionCost(solution);
  bestSolutionAge = 0;

  tabu = zeros(size(solution));

  i = 1;
  while true
    neighbours = getSolutionNeighbours(solution, 5);

    nontabuNeighbours = neighbours(isNontabu(neighbours, solution, tabu), :);

    [bestNeighbour, bestNeighbourCost] = getBestSolution(neighbours);
    [bestNontabuNeighbour, bestNontabuNeighbourCost] = getBestSolution(nontabuNeighbours);

    tabuUpdate = true;

    if bestNontabuNeighbourCost < bestSolutionCost
      nextSolution = bestNontabuNeighbour;

      bestSolution = bestNontabuNeighbour;
      bestSolutionCost = bestNontabuNeighbourCost;
      bestSolutionAge = 0;

    elseif bestNeighbourCost < bestSolutionCost
      nextSolution = bestNeighbour;

      bestSolution = bestNeighbour;
      bestSolutionCost = bestNeighbourCost;
      bestSolutionAge = 0;

      tabuUpdate = false;

    elseif bestNontabuNeighbourCost ~= Inf
      nextSolution = bestNontabuNeighbour;
      bestSolutionAge = bestSolutionAge + 1;

    else
      nextSolution = solution;
      bestSolutionAge = bestSolutionAge + 1;

    endif

    tabu(tabu > 0) = tabu(tabu > 0) - 1;

    if tabuUpdate
      tabu(nextSolution != solution) = tabu(nextSolution != solution) + tenure;
    endif

    solution = nextSolution;

    printIteration('ts', i, bestSolution, bestSolutionCost);
    i = i + 1;

    if bestSolutionAge > bestSolutionAgeMax
      break
    endif

  endwhile

function isNontabu = isNontabu(neighbours, solution, tabu)
  isNontabu = ~isTabu(neighbours, solution, tabu);

function isTabu = isTabu(neighbours, solution, tabu)
  for i = 1:size(neighbours, 1)
    isTabu(i) = all(tabu(neighbours(i) ~= solution) == 0);
  endfor
