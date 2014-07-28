function printIteration(algorithm, iteration, bestSolution, bestSolutionCost)
    fprintf(
        '%s, %i, %4f, %4f \n',
        algorithm, iteration, bestSolutionCost, cputime()
    )
