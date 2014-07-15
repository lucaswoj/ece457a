function [best_solution, best_cost] = tabuSearchTSP (cost_matrix, tabu_tenure, num_iterations)

    
    [initial_solution, initial_cost] = getInitialSolution(cost_matrix,1);
    
    % If you'd like to start with predetermined solution
    % comment the previous line and intialize the following paratmeters:
    % initial_solution = [1 2 4 3 5];
    % initial_cost = 35;

    disp('-------------------------------------------------------------------------------------------------------------');
    fprintf('-------- INITIAL SOLUTION: '); disp(initial_solution);
    fprintf('-------- INITIAL COST: %d \n',initial_cost);
    disp('-------------------------------------------------------------------------------------------------------------');
    
    [num_rows, num_columns] = size(cost_matrix); % Number of nodes.
    num_nodes = num_rows;
    
    % Tabu list intialization to zero.
    tabu_list = initializeTabuList(num_nodes);
    
    current_solution = initial_solution; % The current solution is the intial solution.
    best_solution = initial_solution;    % The best solution is the intial solution.
    best_cost = initial_cost;            % The min. cost is the cost of the intial solution. 

    for i=1:num_iterations
        fprintf('\n--------------- ITERATION %d ---------------\n',i);
        % Obtaining best neighboring solution.
        [best_neighborhood_solution, best_neighborhood_cost, tabu_list] = getNeighborhood (current_solution, best_cost, tabu_list, tabu_tenure, cost_matrix);
        
        % The obtained neighboring solution is the current solution.
        current_solution = best_neighborhood_solution;
        
    	% Comparing if it's the best solution so far.
        if (best_neighborhood_cost < best_cost)
            best_solution = best_neighborhood_solution;
            best_cost = best_neighborhood_cost;
        end 
    end
    
    disp('-------------------------------------------------------------------------------------------------------------');
    fprintf('-------- THE BEST SOLUTION OBTAINED IN %d ITERATIONS: ',num_iterations); disp(best_solution);
    fprintf('-------- COST OF THE BEST SOLUTION: %d \n',best_cost);
    disp('-------------------------------------------------------------------------------------------------------------');
end

function [best_neighborhood_solution, best_neighborhood_cost, tabu_list] = getNeighborhood (current_solution, best_cost, tabu_list, tabu_tenure, cost_matrix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that obtains the best neighboring solution by realzing a set of
% modifications in the current solution. 
% Generate different neighboring solutions by swapping and keep the solution with min. cost.
% Input parameters:
%   - current_solution: current solution.
%   - best_cost: cost of the best solution obatined so far.
%   - tabu_tenure: number of iterations a swapping will be in the tabu list.
%   - tabu_list: Tabu list.
%   - cost_matrix: Mcost matrix.
% Output parameters:
%   - best_neighborhood_solution: best neighboring solution obtained.
%   - best_neighborhood_cost: cost of the best neighboring solution obatined.
%   - tabu_list: Tabu list.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('\nTHE BEST KNOWN SOLUTION COST: %d \n',best_cost);
    fprintf('\nCURRENT SOLUTION: ');disp(current_solution);
    
    best_neighborhood_solution = [];
    best_neighborhood_cost = 0;
    best_node1 = 0;
    best_node2 = 0;
    
    min_cost = 0;
    num_nodes = length(current_solution);
    
    for i=2:num_nodes
        % Obtaining all possible neighboring solutions.
        for j=i+1:num_nodes
            neighborhood_solution = current_solution;
            % Node (i, j) swapping.
            neighborhood_solution(i) = current_solution(j);
            neighborhood_solution(j) = current_solution(i);
            
            fprintf('- CANDIDATE NEIGHBORHOOD SOLUTION:'); disp(neighborhood_solution);
            
            % Checking that the swap is not in the tabu.
            neighborhood_cost = getCostSolution (neighborhood_solution, cost_matrix);
            % Penalizing the moves that are more frequent for diversifying the search.
            swapping_frecuency = getSwappingFrecuency(neighborhood_solution(i),neighborhood_solution(j),tabu_list);
            diversification_cost = neighborhood_cost + swapping_frecuency;
                
            if (isTabu(neighborhood_solution(i),neighborhood_solution(j),tabu_list) == false)
                % Is not a tabued solution.
                
                fprintf('--- COST: %d + %d = %d\n\n',neighborhood_cost,swapping_frecuency,diversification_cost);
                
                if ((min_cost == 0) || (diversification_cost < min_cost))
                    % best solution obatined so far
                    min_cost = diversification_cost;
                    best_neighborhood_solution = neighborhood_solution;
                    best_neighborhood_cost = neighborhood_cost;
                    best_node1 = neighborhood_solution(i);
                    best_node2 = neighborhood_solution(j);
                end
            else
                % Is a tabued solution:
                % To avoid stagnation, apply asipration criteria
                % If the cost of the solution is less that the cost of best solution obatined so far, accept this solution
                if (diversification_cost < best_cost)
                    % best solution obatined so far.
                    min_cost = diversification_cost;
                    best_neighborhood_solution = neighborhood_solution;
                    best_neighborhood_cost = neighborhood_cost;
                    best_node1 = neighborhood_solution(i);
                    best_node2 = neighborhood_solution(j);
                    disp('- TABU SOLUTION ALLOWED - ASPIRATION CRITERIA:'); disp(neighborhood_solution);
                    fprintf('- ALLOWED TABU COST: %d + %d = %d\n',neighborhood_cost,swapping_frecuency,diversification_cost);
                else
                    % Tabued solution is not permited.
                    fprintf('- IS A TABU NEIGHBORHOOD SOLUTION:'); disp(neighborhood_solution);
                    fprintf('--- TABU COST: %d + %d = %d\n\n',neighborhood_cost,swapping_frecuency,diversification_cost);
                end
            end
        end
    end
    
    % afterm obtaining the best neighborhoodcsolution, update the tabu list
    tabu_list = updateTabuList(tabu_list);
    fprintf('\nADD (%d,%d) TO TABU LIST: \n',best_node1,best_node2);
    tabu_list = addSwappingTabuList(best_node1,best_node2,tabu_list,tabu_tenure);
    
    disp(tabu_list);
end

function [tabu_list] = initializeTabuList (num_nodes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funciton to intialize the memory structure of the tabu list to zero 
% Input parameters:
%   - num_nodes: Number of nodes.
% Output parametersa:
%   - tabu_list: tabu list intialized to zero.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    for i=1:num_nodes
        for j=1:num_nodes
            tabu_list(i,j) = 0;
        end
    end
end

function [tabu_list] = updateTabuList (tabu_list)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to update tabu list in every iteration
% Input parameters:
%   - tabu_list: tabu list.
% Output parameters:
%   - tabu_list: Updated tabu list.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [num_rows,num_columns] = size(tabu_list);
    num_nodes = num_rows;
    
    for i=1:num_nodes
        for j=i+1:num_nodes
            if (tabu_list(i,j) > 0)
                tabu_list(i,j) = tabu_list(i,j) - 1;
            end
        end
    end
end

function [tabu_list] = addSwappingTabuList (node1, node2, tabu_list, tabu_tenure)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to add a swapping to the tabu list controlling the frequency of this swapp.
% Input parameters:
%   - node1, node2: swapping nodes.
%   - tabu_list: tabu list.
%   - tabu_tenure: tabu tenure.
% Output parameters:
%   - tabu_list: Updated tabu list.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if (node1 < node2)
        % Inicializamos al valor de tabu_tenure el tiempo que va a estar el
        % swapping en la lista tabú.
        tabu_list(node1,node2) = tabu_tenure;
        % Incrementamos el número de veces que hemos hecho este swapping.
        tabu_list(node2,node1) = tabu_list(node2,node1) + 1;
    else
        % Inicializamos al valor de tabu_tenure el tiempo que va a estar el
        % swapping en la lista tabú.
        tabu_list(node2,node1) = tabu_tenure;
        % Incrementamos el número de veces que hemos hecho este swapping.
        tabu_list(node1,node2) = tabu_list(node1,node2) + 1;
    end
end

function [is_tabu_solution] = isTabu (node1, node2, tabu_list)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to check the solution is listed as tabued. 
% Input parameters:
%   - node1, node2: swapping nodes.
%   - tabu_list: tabu list.
% Output parameters:
%   - is_tabu_solution: boolean variable to indicate the solution is taubed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    is_tabu_solution = false;
    
    if (node1 < node2)
        % Checking the swap (node1,node2) in tabu list.
        if (tabu_list(node1,node2) > 0)
            % Is a tabued solution.
            is_tabu_solution = true;
        end
    else
        % Checking the swap (node2,node1) in tabu list.
        if (tabu_list(node2,node1) > 0)
            % Is a tabued solution.
            is_tabu_solution = true;
        end
    end
end

function [swapping_frecuency] = getSwappingFrecuency (node1, node2, tabu_list)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to obtain the sawpping frequency
% Input parameters:
%   - node1, node2: swapping nodes.
%   - tabu_list: tabu list.
% Output parameters:
%   - is_tabu_solution: boolean variable to indicate the solution is taubed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if (node1 < node2)
        % Obtaining the value of the swap (node2,node1) from the tabu list.
        swapping_frecuency = tabu_list(node2,node1);
    else
        % Obtaining the value of the swap (node1,node2) from the tabu list.
        swapping_frecuency = tabu_list(node1,node2);
    end
end

function [cost_solution] = getCostSolution (solution, cost_matrix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to obtain the cost of a solution.
% Input Parameters:
%   - solution: solution that we want to obtain its cost.
%   - cost_matrix: cost matrix.
% Output parameters:
%   - cost_solution: solution cost.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    cost_solution = 0;
    for i=1:(length(solution) - 1)
        cost_solution = cost_solution + cost_matrix(solution(i),solution(i+1));
    end
    % Total cost between intial and final nodes.
    cost_solution = cost_solution + cost_matrix(solution(length(solution)),solution(1));
end

function [initial_path, total_cost] = getInitialSolution (cost_matrix, initial_node)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to obtain the intial solution selecting the most nearest nodes.
% Input parameters:
%   - cost_matrix: cost matrix.
%   - initial_node: initial node.
% Output parameters:
%   - initial_path: initial path.
%   - total_cost: total cost.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [num_rows, num_columns] = size(cost_matrix);
    
    num_nodes = num_rows; % Number of nodes.

    initial_path(1) = initial_node;
    total_cost = 0; % Total cost.
    
    while (length(initial_path) < num_nodes)
        current_node = initial_path(length(initial_path)); % Nodo actual.

        % List of costs for the current nodes:
        node_cost_list = cost_matrix(current_node,:);
        
        % The mearest node:
        [nearest_node, min_cost] = getNearestNode (node_cost_list, initial_path);
        
        initial_path(length(initial_path) + 1) = nearest_node;
        total_cost = total_cost + min_cost;
    end
    
    % Including the intial node.
    total_cost = total_cost + cost_matrix(nearest_node, initial_node);

end

function [is_visited_node] = inVisitedNodes (node, visited_nodes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to check if the node is already visited.
% Input parameters:
%   - node: ndoe to be checked.
%   - visited_nodes: visited node.
% Output parameters:
%   - is_visited_node: boolean variable to indiciate if the node is visited.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    is_visited_node = false;
    num_visited_nodes = length(visited_nodes);
    
    for i=1:num_visited_nodes
        if (node == visited_nodes(i))
            is_visited_node = true;
            break;
        end
    end
end

function [nearest_node, min_cost] = getNearestNode (node_cost_list, initial_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to obtain the nearest nodes to the current one that has not been visited before
% Input parameters:
%   - node_cost_list: vector of the costs of the current node.
%   - initial_path: path obatined so far.
% Output Parameters:
%   - nearest_node: nearest node.
%   - min_cost: cost to go to the nearest node.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    num_nodes = length(node_cost_list); % Number of nodes.
    visited_nodes = initial_path;
    min_cost = 0; % Minimum cost.
    nearest_node = 0; % Selected node.
    
    for node=1:num_nodes
        % Checking that we have not visited this node before.
        if (inVisitedNodes(node, visited_nodes) == false)
            % Not visted node
            if ((min_cost == 0) || (node_cost_list(node) < min_cost))
                % The nearest node so far.
                min_cost = node_cost_list(node);
                visited_nodes(size(visited_nodes) + 1) = node;
                nearest_node = node;
            end     
        end
    end
end