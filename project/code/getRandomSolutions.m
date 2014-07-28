function solutions = getRandomSolutions(population = 1)
  global nTasks tasks nRobots robots nHomes homes priorities skills distances;

  solutionLength = nTasks + nRobots - 1;

  % Generate a vector with an entry for every task and every home.
  solutions = repmat(1:solutionLength, population, 1);

  % Replace all home values with 0s.
  solutions(solutions > nTasks) = 0;

  % Permute the solutions
  for i=1:population
    solutions(i, :) = solutions(i, randperm(solutionLength));
  endfor
