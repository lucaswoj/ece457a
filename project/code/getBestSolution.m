function [bestSolution, bestCost] = getBestSolution(solutions)
  bestCost = Inf;
  bestSolution = [];

  for i = 1:size(solutions, 1)

    solution = solutions(i, :);
    cost = getSolutionCost(solution);

    if cost < bestCost
      bestCost = cost;
      bestSolution = solution;
    endif
  endfor