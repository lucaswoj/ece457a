function [MST MSTCost] = Kruskal(Graph)

% Get the number of nodes and edges in the Graph
NumNodes = size(Graph, 1);
NumEdges = nnz(Graph) / 2;

% Initialize the spanning tree
MST = sparse(NumNodes, NumNodes);

% Get a list of the edges in the graph in the form of (N1, N2)
[N1 N2 V] = find(Graph);
IdxToKeep = N1<N2;       % Keep the edge if N1 < N2
N1 = N1(IdxToKeep);      N2 = N2(IdxToKeep);
V = V(IdxToKeep);

% Initialize the sub-tree identifier
Subtree = 1:NumNodes;

% Sort the edges by weight
[VSorted, IdxSorted] = sort(V);
N1 = N1(IdxSorted);
N2 = N2(IdxSorted);

% Keep adding edge without making cycles
while size(V) > 0

    if Subtree(N1(1)) ~= Subtree(N2(1))
        MST(N1(1), N2(1)) = 1;
        MST(N2(1), N1(1)) = 1;

        Subtree(Subtree == Subtree(N2(1))) = Subtree(N1(1));
    end

    % Remove the first edge
    V(1) = [];
    N1(1) = [];
    N2(1) = [];

    V = V + 10 ./ (1 + exp(-1 * N1 ./ 10)) + 10 ./ (1 + exp(-1 * N2 ./ 10));
    [VSorted, IdxSorted] = sort(V);
    N1 = N1(IdxSorted);
    N2 = N2(IdxSorted);
end

% Calculate the cost of the minimum spanning tree
MSTCost = sum(sum(Graph .* MST)) / 2;