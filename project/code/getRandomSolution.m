function solution = getRandomSolution()
  global nTasks tasks nRobots robots nHomes homes priorities skills distances;

  solutionLength = nTasks + nRobots - 1;

  % Generate a vector with an entry for every task and every home.
  solution = 1:solutionLength;

  % Replace all home values with 0s.
  solution(solution > nTasks) = 0;

  % Permute the solution
  solution = solution(randperm(solutionLength));