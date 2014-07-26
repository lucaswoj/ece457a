function solution = normalizeSolution(solution)
    if solution(1) ~= 0
        solution = [0, solution]
    endif

    if solution(length(solution)) ~= 0
        solution = [solution, 0]
    endif