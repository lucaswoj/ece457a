function [MST MSTCost] = Kruskal(Graph)

% Get the number of nodes and edges in the Graph
NumNodes = size(Graph, 1);
NumEdges = nnz(Graph) / 2;

% Initialize the spanning tree
MST = sparse(NumNodes, NumNodes);

% Get a list of the edges in the graph in the form of (N1, N2)
[N1 N2 EdgeCosts] = find(Graph);
IdxToKeep = N1<N2;       % Keep the edge if N1 < N2
N1 = N1(IdxToKeep);      N2 = N2(IdxToKeep);
EdgeCosts = EdgeCosts(IdxToKeep);

% Initialize the sub-tree identifier
Subtree = 1:NumNodes;

% Sort the edges by weight
[CostsSorted, CostsSortedIndicies] = sort(EdgeCosts);
N1 = N1(CostsSortedIndicies);
N2 = N2(CostsSortedIndicies);

% Keep adding edge without making cycles
while max(size(EdgeCosts)) > 1

    if Subtree(N1(1)) ~= Subtree(N2(1))
        MST(N1(1), N2(1)) = 1;
        MST(N2(1), N1(1)) = 1;

        Subtree(Subtree == Subtree(N2(1))) = Subtree(N1(1));
    end

    % Remove the first edge
    EdgeCosts(1) = [];
    N1(1) = [];
    N2(1) = [];

    % Recompute all node costs
    NodeCosts = (10 ./ (1 + exp(-1 * sum(MST).' ./ 10))) - ...
        (10 ./ (1 + exp(-1 * sum(MST - 1).' ./ 10)));

    % Recompute all overall costs
    Costs = EdgeCosts + NodeCosts(N1) + NodeCosts(N2);
    [CostsSorted, CostsSortedIndicies] = sort(Costs);
    N1 = N1(CostsSortedIndicies);
    N2 = N2(CostsSortedIndicies);
end

% Calculate the cost of the minimum spanning tree
MSTCost = GetCost(Graph, MST);