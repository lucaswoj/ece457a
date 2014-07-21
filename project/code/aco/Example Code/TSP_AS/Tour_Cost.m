function L=Tour_Cost(tour,D)
% calculating the length of a tour
    n=numel(tour);
    tour=[tour tour(1)]; %[24 18 24] backing to first city
    L=0;
    for i=1:n
        L=L+D(tour(i),tour(i+1));
    end
end