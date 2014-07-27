function printIteration(algorithm, iteration, bestCost)
    fprintf(
        '%s, %i, %4f, %4f \n',
        algorithm, iteration, bestCost, cputime()
    )
