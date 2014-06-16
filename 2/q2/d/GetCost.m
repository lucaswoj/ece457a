function Cost = GetCost(Graph, ST)

EdgeCost = sum(sum(Graph .* ST)) / 2;
NodeCost = sum(10 ./ (1 + exp(-1 * sum(Graph) ./ 10)));

Cost = EdgeCost + NodeCost;