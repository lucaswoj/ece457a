function [bestSolution, bestSolutionCost] = solve(nIterations = 100)
  global nTasks tasks nRobots robots nHomes homes priorities skills distances;

  % TODO tune this
  nParticles = 10

  positions = getRandomSolutions(nParticles);
  lbestPositions = positions;
  lbestScores = zeros(1, nParticles);

  velocityLength = nParticles * 10;
  velocities = zeros(nParticles, velocityLength, 2);

  [positionGbest, costGbest] = getBestSolution(positions)

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
        positionGbest,
        unpadVelocity(squeeze(velocities(j, :, :)))
      );
      position = addVelocityPosition(velocity, positions(j, :));

      velocities(j, :, :) = padVelocity(velocity, velocityLength);
      positions(j, :) = position;

      cost = getSolutionCost(position);

      if (cost < lbestScores(j))
        lbestPositions(j, :) = position;
        lbestScores(j) = cost;
      endif

      if (cost < costGbest)
        positionGbest = position;
        costGbest = cost;
      endif

    endfor

    printIteration('pso', i, costGbest);

  endfor

