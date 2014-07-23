function neighbours = getSolutionNeighbours(solution, n)
  global nTasks tasks nRobots robots nHomes homes priorities skills distances;

  solutionLength = length(solution);

  neighbours = zeros(n, solutionLength);

  for i = 1:n
    pair = randperm(solutionLength, 2);

    neighbours(i, :) = solution;
    neighbours(i, pair) = solution([pair(2), pair(1)]);
  endfor
