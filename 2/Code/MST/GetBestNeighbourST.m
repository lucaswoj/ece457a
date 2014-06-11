function [BestNeighbourST BestNeighbourSTCost TabuEdges] ...
                = GetBestNeighbourST(Graph, ST, ... 
                TabuEdges, TabuLength)

% This function gets the neighbour of the given spanning tree 
% with the lowest cost.
%
% Inputs:
%   Graph: A spare matrix that represents undirected graph. The element
%          (i, j) represents the weigh of the edge between nodes i and j. 
%          The matrix has to be symmetric.
%   ST:  A spare matrix that represents the spanning tree obtained. 
%        The element (i,j) is 1 if nodes i and j are connected in the tree, 
%        otherwise it's 0. The matrix is symmetric.
%   TabuEdges: A matrix that represents the edges that are not allowed to
%               be removed from the current solution.
%   TabuLength: The length of the tabu list

BestNeighbourST = ST;
BestNeighbourSTCost = Inf;

% Get the number of nodes and edges in the Graph
NumNodes = size(Graph, 1);
NumEdges = nnz(Graph) / 2;

% Get the number of edges in the given spanning tree
NumTreeEdges = nnz(ST) / 2;

% Get a list of the edges in the graph in the form of (N1, N2)
[N1 N2] = find(Graph);
IdxToKeep = N1<N2;       % Keep the edge if N1 < N2
N1 = N1(IdxToKeep);      N2 = N2(IdxToKeep);

% Get a list of the edges in the spanning tree in the form of (NT1, NT2)
[NT1 NT2] = find(ST);
IdxToKeep = NT1<NT2;      % Keep the edge if NT1 < NT2
NT1 = NT1(IdxToKeep);     NT2 = NT2(IdxToKeep);

% A flag to indicate whether a tabu move to be added to the tabu list or
% not
AddTabuMove = false;

% Repeat for each edge in the spanning tree
for e1 = 1:NumTreeEdges
    % Consider the replacement of that edge with another feasible one
    
    % 1. Calculate the cost of the new spanning tree 
    
    % Get a copy of the current spanning tree
    NewST = ST;
    
    % Assign all nodes in the new tree to the same sub-tree
    SubtreeId = zeros(1, NumNodes);

    % Remove the current edge from the new spanning tree
    NewST(NT1(e1), NT2(e1)) = 0;
    NewST(NT2(e1), NT1(e1)) = 0;
    
    % Assign the nodes connected to N1(e), N2(e) to different sub-trees
    % (Get the set of nodes connected to N2(e) and assign them to 
    % a different subtree)
    Nodes = NT2(e1);                      
    while ~isempty(Nodes);
        SubtreeId(Nodes) = 1;
        % Get the nodes in NewST connected to Nodes & from subtree 0
        Nodes = find( sum(NewST(Nodes, :), 1) & SubtreeId == 0);
    end
        
    % Search for the best edge in the graph that can replace the current
    % edge
    BestEdge = -1;
    BestEdgeWeight = Inf;    
    for e2 = 1:NumEdges
        % Skip the edge to be removed
        if NT1(e1) == N1(e2) && NT2(e1) == N2(e2) 
            continue
        end
        % Check that the nodes connected by the edge to be added are not 
        % in the same sub-trees (to avoid cycles)
        if SubtreeId(N1(e2)) ~= SubtreeId(N2(e2))
            CurrEdgeWeight = Graph(N1(e2), N2(e2));
            if CurrEdgeWeight < BestEdgeWeight 
                BestEdge = e2;
                BestEdgeWeight = CurrEdgeWeight;
            end
        end
    end   
    
    % Continue looping if there's no better edge to replace e1
    if BestEdge == -1
        continue
    end
    
    % If a better edge is found, add it to the new spanning tree
    NewST(N1(BestEdge), N2(BestEdge)) = 1;
    NewST(N2(BestEdge), N1(BestEdge)) = 1;
    
    % Caclulate the cost of the new spanning tree
    NewSTCost = sum(sum(Graph .* NewST)) / 2;
        
    % 2. Check if the edge to be removed (e1) is in the tabu list
    if TabuEdges(NT1(e1), NT2(e1)) == 0
        if NewSTCost < BestNeighbourSTCost
            BestNeighbourST = NewST;
            BestNeighbourSTCost = NewSTCost;
            
            TabuEdgeN1 = N1(BestEdge);
            TabuEdgeN2 = N2(BestEdge);    
            AddTabuMove = true;
        end       
    end
end

% Update the Tabu list
TabuEdges = TabuEdges - 1;
TabuEdges(TabuEdges<0) = 0;

% Add new edges to the tabu list (if any)
if AddTabuMove
    % When an edge is added to the tree, it should not be removed from the 
    % tree during the next TabuLenght iterations
    TabuEdges(TabuEdgeN1, TabuEdgeN2) = TabuLength;
    TabuEdges(TabuEdgeN2, TabuEdgeN1) = TabuLength;
end

