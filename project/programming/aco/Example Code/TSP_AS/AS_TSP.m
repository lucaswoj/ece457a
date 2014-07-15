%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ant Colony Optimization for Traveling Salesman Problem (TSP)   %
%                                                                %
% Programmed By: Hamid Behravan                                  %                                                
% 
% this program runs correctly for a full graph. In a full graph all nodes are connected to each other.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear
disp('ANT Colony Optimization (ACO) for');
disp('Traveling Salesman Problem (TSP)');


D=DistanceMatrix();
nCity=size(D,1);

etha=(1./D);  % the heurstic information
etha(find(etha == Inf))=0.0000001;   %   In case d(ij) = 0 for some arc (i, j), the corresponding etha(ij) is set to a very small value.
tau0=1;
tau=tau0*ones(nCity,nCity);  % the desirability matrix, to be one for all arcs. (same probability)

alpha=1;
beta=2;

rho=0.5;

nAnt=nCity;

empty_ant=struct();
empty_ant.Tour=[];  % city locations
empty_ant.L=0;  % contains the length of tours
empty_ant.P=[]; % the probability of going from city i to city j

ant=repmat(empty_ant,nAnt,1);

max_it=200;
best_L=repmat(nan,max_it,1);

for t=1:max_it          % iterations
      
    for k=1:nAnt        % placing ants at random positions. in total 25 ants at 25 cities.
        ant(k).Tour=randint(1,1,[1 nCity]);
    end 
    
    for i=2:nCity  % first all ants choose their desired next city and then move to their next desired until the make a complete tour.     
        
        for k=1:nAnt  %% Ants goes in parrallel
            N=find(~ismember(1:nCity,ant(k).Tour));   % location of non visited cities
            ant(k).P=zeros(1,nCity);                  % 1*25 matrics 
            ii=ant(k).Tour(end);                      % location of start city, (backing to starting city)
            
            % tour construction
            for j=1:numel(N)  %probability from city i to city j 
                jj=N(j);  % non visited city locations
                ant(k).P(jj)=tau(ii,jj)^alpha*etha(ii,jj)^beta;
            end 
         
            ant(k).P=ant(k).P/sum(ant(k).P);  % normalizing the probabilites.
            ant(k).Tour(end+1)=Probability(ant(k).P); % adding cities one by one until we get the complete k visited cities
        end 
     
    end 
    % tours were constructed for all ants. now ants have visited all cities
    % once and made a complete visit.
    
    
    % pheromone updates 
    for k=1:nAnt 
        
        ant(k).L=Tour_Cost(ant(k).Tour,D);            % calculating the sum of distances in each tour for ant k
        
        for i=1:nCity 
            ii=ant(k).Tour(i); % the location of first city
            
            if i<nCity
                jj=ant(k).Tour(i+1); % containing the next city after city i
            else
                jj=ant(k).Tour(1); % backing to first node
            end
            
            %Updating the pheromone trails
            tau(ii,jj)=tau(ii,jj)+1/ant(k).L; % previous plus the new pheremone. we uses the pheromones remained by all ants.
            tau(jj,ii)=tau(ii,jj);  % symmetric matrix
        end 
        
        VisitedCities{t,k} = ant(k).Tour;
        VisitedCitiesLength{t,k} = ant(k).L;
        
    end 
    tau=(1-rho)*tau;                             % Pheremone Evaporation effect
     
    best_L(t)=min(min([ant.L]),min(best_L)); % best tour, % ant.L: represents the tour lengths made by all ants(25*1);
    %at each iteration it will change;  best_L: the previous best tour length.
    
    disp(['Iteration ' num2str(t) ': Best Tour Length = ' num2str(best_L(t))]);
end 
aco_result=best_L;

plot(1:max_it,best_L);
xlabel('Iterations')
ylabel('Optimal Tour at each iteration')
title('Plot of optimal tours VS iterations')


% what is the most optimal tour
VisitedCitiesLength = cell2mat(VisitedCitiesLength);
[a,b] = min(VisitedCitiesLength);
[c,d] = min (a);

best_tour_acheived = VisitedCities{b(d),d};
