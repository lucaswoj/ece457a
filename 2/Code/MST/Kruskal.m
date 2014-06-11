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

% Sort the edges by weight
[VSorted, IdxSorted] = sort(V);
N1 = N1(IdxSorted);      N2 = N2(IdxSorted);  

% Initialize the sub-tree identifier
Subtree = 1:NumNodes;

% Keep adding edge without making cycles
for e = 1:NumEdges
    if Subtree(N1(e)) ~= Subtree(N2(e))     
        MST(N1(e), N2(e)) = 1;
        MST(N2(e), N1(e)) = 1;
        
        Subtree(Subtree == Subtree(N2(e))) = Subtree(N1(e));
    end        
end

% Calculate the cost of the minimum spanning tree
MSTCost = sum(sum(Graph .* MST)) / 2;