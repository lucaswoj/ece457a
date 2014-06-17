% An industrial communication company is planning to lay cables to a new factory
% allowing all the factory’s units to be linked for the interchange of data. If
% it is constrained to bury the cable only along certain paths, then there would
% be an undirected graph representing which points are connected by those paths.
% Some of those paths might be more expensive, because they are longer, or
% require the cable to be buried deeper; these paths would be represented by
% edges with larger weights. For example, Figure 1 shows 5 factory’s units and
% the possible paths along which the cables can be buried.

% The minimum spanning tree (MST) of the graph that represents the factory’s
% units and paths can be used to decide the most cost-effective paths for laying
% cables. MST is a tree that spans all the nodes of the graph with a minimum
% cost. MST is widely used in different applications such as communication
% network, transportation networks, scheduling and data clustering. Different
% greedy algorithms have been proposed for finding a MST such as Prim-Jarnik,
% Kruskal’s and Baruvka’s Algorithms.

% In this problem, a MATLAB code that implements the Tabu Search algorithm for
% finding the MST of an undirected graph is given:

% a) Use the given functions to find the most cost-effective paths for the graph
% given in Units100.mat and report the total cost of laying the cables.

% b) Run the code with different tabu list lengths (5, 10, 15, 25, 50) and
% report the cost obtained in each case. What do you observe?

warning('off','all');

load Units100.mat

TabuIterations = 100;
TabuLengths = [5, 10, 15, 25, 50];

fprintf('\n\n');
fprintf('Running Kruskal’s Algorithm\n');
[KruskalMST, KruskalCost] = Kruskal(Graph);
fprintf('Lowest Cost: %d\n');
fprintf('\n\n');

for i = 1:numel(TabuLengths)
    TabuLength = TabuLengths(i);

    fprintf('\n\n');
    fprintf('Running Tabu Search (Length: %d, Iterations: %d)\n', TabuLength, TabuIterations)
    [TabuMST, TabuCost] = TabuSearch(Graph, TabuLength, TabuIterations, @GenInitialST, @GetBestNeighbourST);
    fprintf('Lowest Cost: %d\n', TabuCost);
    fprintf('\n\n');
end