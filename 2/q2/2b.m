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

% b) Run the code with different tabu list lengths (5, 10, 15, 25, 50) and
% report the cost obtained in each case. What do you observe?

load Units100.mat

Iterations = 5;

Lengths = [5, 10, 15, 25, 50];
for i = 1:numel(Lengths)
    Length = Lengths(i);
    [MST, Cost] = TabuSearch(Graph, 50, Iterations, @GenInitialST, @GetBestNeighbourST);

    fprintf('\n\nIterations: %d\nTabu length: %d\nCost: %d\n\n', Iterations, Length, Cost);
end