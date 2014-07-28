function [bestSolution, bestSolutionCost] = solve(nIterations = 100)
  global nTasks tasks nRobots robots nHomes homes priorities skills distances;

  % TODO tune this
  nParticles = 10;

  positions = getRandomSolutions(nParticles);
  lbestPositions = positions;
  lbestScores = zeros(1, nParticles);

  velocities = cell(nParticles, 1);
  velocities(:) = zeros(0, 2);

  [gbestPosition, gbestCost] = getBestSolution(positions);

  for i=1:nIterations

    nextVelocities = zeros(nParticles, nParticles, 2);
    r1 = rand();
    r2 = rand();

    for j=1:nParticles

      velocity = getNextVelocity(
        r1,
        r2,
        positions(j, :),
        lbestPositions(j, :),
        gbestPosition,
        velocities{j}
      );
      position = addVelocityPosition(velocity, positions(j, :));

      velocities{j, 1} = velocity;
      positions(j, :) = position;

      cost = getSolutionCost(position);

      if (cost < lbestScores(j))
        lbestPositions(j, :) = position;
        lbestScores(j) = cost;
      endif

      if (cost < gbestCost)
        gbestPosition = position;
        gbestCost = cost;
      endif

    endfor

    printIteration('pso', i, gbestPosition, gbestCost);

  endfor
