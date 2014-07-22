           
function i=Probability(P)
% choosing a direction by comparison between edges probability with a
%random variable between [0,1]
%     r=rand;
%     C=cumsum(P);
%     ii=find(C>=r);
%     i=ii(1);

[ii i] = max(P);  %% selecting based on the most probable arc.
end
