function generateProblem(numTasks, numRobots)
	assert(numTasks > 0 && numRobots > 0);

	global nRobots velocities energy homes nTasks priorities skills taskTimes distances;

	nRobots = numRobots;
	nTasks  = numTasks;

	velocities = rand(1, nRobots);
	distances  = rand(nTasks+nRobots, nTasks+nRobots);
	priorities = rand(1, nTasks);
	skills     = rand(nRobots, nTasks);
	taskTimes  = rand(nRobots, nTasks);

	perTaskEnergy = nTasks/nRobots;
	energy = zeros(1, nRobots);
	for i = 1:nRobots
		energy(i) = perTaskEnergy*(10*rand);
	endfor