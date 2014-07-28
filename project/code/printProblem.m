function printProblem(name)
  global nRobots velocities energy homes nTasks priorities skills taskTimes distances;

  warning('off');

  fprintf('function load%sProblem()\n', name);

  fprintf('\tglobal nRobots velocities energy homes nTasks priorities skills taskTimes distances;\n');

  fprintf('\tnRobots = %s;\n\n', uneval(nRobots)(1:end - 1));
  fprintf('\tvelocities = %s;\n\n', uneval(velocities)(1:end - 1));
  fprintf('\tenergy = %s;\n\n', uneval(energy)(1:end - 1));
  fprintf('\thomes = %s;\n\n', uneval(homes)(1:end - 1));
  fprintf('\tnTasks = %s;\n\n', uneval(nTasks)(1:end - 1));
  fprintf('\tpriorities = %s;\n\n', uneval(priorities)(1:end - 1));
  fprintf('\tskills = %s;\n\n', uneval(skills)(1:end - 1));
  fprintf('\ttaskTimes = %s;\n\n', uneval(taskTimes)(1:end - 1));
  fprintf('\tdistances = %s;\n\n', uneval(distances)(1:end - 1));