function [ST STCost TabuEdges] = GenInitialST(Graph)

% This function generates a random spanning tree for a graph.
% 
% Inputs:
%   Graph: A spare matrix that represents undirected graph. The element
%          (i, j) represents the weigh of the edge between nodes i and j. 
%          The matrix has to be symmetric.
%
% Outputs:
%   ST:  A spare matrix that represents the spanning tree obtained. 
%        The element (i,j) is 1 if nodes i and j are connected in the tree, 
%        otherwise it's 0. The matrix is symmetric.
%   STCost: The cost of the output spanning tree

% Get the number of nodes and edges in the Graph
NumNodes = size(Graph, 1);
NumEdges = nnz(Graph) / 2;

% Initialize the spanning tree
ST = sparse(NumNodes, NumNodes);

% Get a list of the edges in the graph in the form of (N1, N2)
[N1 N2] = find(Graph);
IdxToKeep = N1<N2;       % Keep the edge if N1 < N2
N1 = N1(IdxToKeep);     N2 = N2(IdxToKeep);

%  Randomly shuffle the list of edges
IdxShuffled = randperm(NumEdges);
N1 = N1(IdxShuffled);   N2 = N2(IdxShuffled); 

% Initially assign each node to a different sub-tree 
SubtreeId = 1:NumNodes;

% Repeat for each edge
for e = 1:NumEdges
    % Check that the nodes connected by the current edge are not 
    % in the same sub-tree
    if SubtreeId(N1(e)) ~= SubtreeId(N2(e))
        % Add the edge to the spanning tree
        ST(N1(e), N2(e)) = 1;
        % Merge the two sub-trees at the end of the current edge
        IdxSubTree2 = (SubtreeId == SubtreeId(N2(e))); 
        SubtreeId(IdxSubTree2) = SubtreeId(N1(e));
    end
end

% Make the spanning tree matrix symmetric
ST = ST + ST';

% Calculate the cost of the spanning tree
STCost = sum(sum(Graph .* ST)) / 2;

% Initialize the tabu list. The tabu list represents that set of edges
% that can't be deleted to find the neighbourhood of the current solution
TabuEdges = sparse(NumNodes, NumNodes);

