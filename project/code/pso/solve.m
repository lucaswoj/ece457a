function [bestSolution, bestSolutionCost] = solve(nIterations = 100)
  global nTasks tasks nRobots robots nHomes homes priorities skills distances;

  if nTasks == 50
    nParticles=25;
    nIterations = 1000;
  elseif nTasks == 15
    nParticles=20;
    nIterations=500;
  elseif nTasks == 5
    nParticles=16;
    nIterations=250;
  else
    nIterations=250;
    nParticles=16;
  endif

  positions = getRandomSolutions(nParticles);
  lbestPositions = positions;
  lbestScores = zeros(1, nParticles);

  velocities = cell(nParticles, 1);
  velocities(:) = zeros(0, 2);

  allTimeAge = 0;
  allTimeBestCost = Inf;

  [gbestPosition, gbestCost] = getBestSolution(positions);

  % Iterations of PSO
  for i=1:nIterations

    nextVelocities = zeros(nParticles, nParticles, 2);
    r1 = rand();
    r2 = rand();
    costs = 1:nParticles;

    % Calculate particle velocities and update positions
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

      costs(j) = getSolutionCost(position);

      if (costs(j) <= lbestScores(j))
        lbestPositions(j, :) = position;
        lbestScores(j) = costs(j);
      endif

    endfor

    gbestCost = Inf;
    for index = 1:nParticles
      if (costs(index) < gbestCost)
        gbestPosition = positions(index, :);
        gbestCost = costs(index);

        if ( gbestCost < allTimeBestCost )
          allTimeBestPosition = positions(index, :);
          allTimeBestCost = gbestCost;
          allTimeAge = 0;
        endif
      endif
    endfor

    % Anti-stagnation measure.
    % If no improvement found for 15 iterations, then
    % "scatter" the particles by "moving" them to random "positions".
    % Half take on the lbest value of the all time best and the other
    % half use their current position as lbest. This is a balance
    % between exploration and exploitation
    allTimeAge = allTimeAge + 1;
    if (allTimeAge > 15)
        for x = 1:nParticles
          newParticle = getRandomSolutions();
          costs(x) = getSolutionCost(newParticle);
          positions(x, :) = newParticle;
          if (mod(x, 2) == 0)
            lbestPositions(x, :) = allTimeBestPosition;
            lbestScores(x) = getSolutionCost(allTimeBestPosition);
          else
            lbestPositions(x, :) = newParticle;
            lbestScores(x) = getSolutionCost(newParticle);
          endif
          velocities{x, 1} = zeros(0,2);
        endfor
        gbestPosition = allTimeBestPosition;

      allTimeAge = 0;
    endif

    printIteration('pso', i, allTimeBestPosition, allTimeBestCost);

  endfor
