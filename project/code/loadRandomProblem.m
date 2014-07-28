function loadRandomProblem(nTasks_, nRobots_)
	assert(nTasks_ > 0 && nRobots_ > 0);

	global nRobots velocities energy homes nTasks priorities skills taskTimes distances;

	nRobots = nRobots_;
	nTasks = nTasks_;

	homes = (1:nRobots) + nTasks;
	velocities = rand(1, nRobots);

	distances  = rand(nTasks + nRobots, nTasks + nRobots);
	distances(logical(eye(size(distances)))) = 0;
	distances(nTasks + 1:nTasks + nRobots, nTasks + 1:nTasks + nRobots) = 0;

	priorities = rand(1, nTasks + nRobots);
	priorities(nTasks + 1:nTasks + nRobots) = 1;

	skills = rand(nRobots, nTasks + nRobots);
	skills(:, nTasks + 1:nTasks + nRobots) = 1;

	taskTimes = rand(nRobots, nTasks + nRobots);
	taskTimes(:, nTasks + 1:nTasks + nRobots) = 0;


	% TODO adjust this algo
	perTaskEnergy = nTasks / nRobots;
	energy = zeros(1, nRobots);
	for i = 1:nRobots
		energy(i) = perTaskEnergy * (1000 * rand);
	endfor

% TODO create central constants file?