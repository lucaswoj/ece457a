cost_matrix = [0 4 2 9 12; 4 0 7 5 5; 2 7 0 4 10; 9 5 4 0 3; 12 5 10 3 0];
tabu_tenure = 3;
num_iterations = 5;

[best_solution, best_cost] = tabuSearchTSP (cost_matrix, tabu_tenure, num_iterations)