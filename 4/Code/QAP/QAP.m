clc;
clear;

% THE DISTANCE/FLOW MATRIX
% UPPER HALF = DISTANCE, LOWER HALF = FLOW
DF = [NaN 1 2 3 1 2 3 4;
        5 NaN 1 2 2 1 2 3;
        2 3 NaN 1 3 2 1 2;
        4 0 0 NaN 4 3 2 1;
        1 2 0 5 NaN 1 2 3;
        0 2 0 2 10 NaN 1 2;
        0 2 0 2 0 5 NaN 1;
        6 0 5 10 0 1 10 NaN];

% PROBLEM SIZE (NUMBER OF SITES OR DEPTS)
pr_size = size(DF, 1);
ants = 5; % NUMBER OF ANTS
max_assigns = 100000; % NUMBER OF ASSIGNMENTS

% (WHEN TO STOP)
optimal = 107; % OPTIMAL SOLUTION
a = 1; % WEIGHT OF PHEROMONE
b = 5; % WEIGHT OF HEURISTIC INFO
lamda = 0.8; % EVAPORATION PARAMETER
Q = 10; % CONSTANT FOR PHEROMONE UPDATING
AM = ones(ants,pr_size); % ASSIGNMENTS OF EACH ANT
min_cost = -1;

% HEURISTIC INFO - SUM OF DISTANCES BETWEEN SITES
for i=1:pr_size
    D(i) =sum( DF(1:i-1,i))+sum(DF(i,i+1:pr_size));
end

% START THE ALGORITHM
assign = 1;
while (assign <= max_assigns) & ( (min_cost > optimal)|(min_cost == -1) )

    % =============== FIND PHEROMONE ===============
    % AT FIRST LOOP, INITIALIZE PHEROMONE
    if assign==1
    % SET 1 AS INITIAL PHEROMONE
    pher = ones(8);
    % IN THE REST OF LOOPS, COMPUTE PHEROMONE
    else
        for i=1:pr_size
            for j=1:pr_size
                tmp = zeros(ants,pr_size);
                tmp(find(AM==j)) = 1;
                tmp = tmp(:,i);
                tmp = tmp .* costs';
                tmp( find(tmp==0) ) = [];
                tmp = Q ./ tmp;
                delta(i,j) = sum(tmp);
            end
        end
        pher = lamda * pher + delta;
    end

   
    % ============ ASSIGN DEPTS TO SITES ============
    % EACH ANT MAKES ASSIGNMENTS

    for ant=1:ants
        % GET RANDOM DEPT ORDER
        depts = rand(pr_size, 2);
        for i=1:pr_size
            depts(i,1) = i;
        end
        depts = sortrows(depts,2);
        % KEEP AVAILABLE SITES IN A VECTOR
        for i=1:pr_size
            free_sites(i) = i;
        end
        pref = ones(pr_size,1); % PREFERENCE FOR EACH SITE
        prob=ones(pr_size,1);% PROBABILITIES FOR EACH DEPT
        for dept_index=1:pr_size
            % GET SUM OF THE PREFERENCES
            % AND THE PREFERENCE FOR EACH SITE
            pref_sum = 0;
        for site_index=1:size(free_sites,2)
            tmp_pher=pher(depts(dept_index),free_sites(site_index));
            pref(site_index) = tmp_pher^a *( 1/D(free_sites(site_index)) )^b;
            pref_sum = pref_sum + pref(site_index);
        end

        % GET PROBABILITIES OF ASSIGNING THE DEPT
        % TO EACH FREE SITE
        prob = free_sites';
        prob(:,2) = pref / pref_sum;
        % GET THE SITE WHERE THE DEPT WILL BE ASSIGNED
        prob = sortrows(prob,2);
        AM(ant,dept_index) = prob(1);
        % ELIMINATE THE SELECTED SITE FROM THE
        % FREE SITES
        index = find(free_sites==prob(1));
        prob(1,:) = [];
        free_sites(index) = [];
        pref(index) = [];
        end
        % GET THE COST OF THE ANT’S ASSIGNMENT
        costs(ant) = 0;
        for i=1:pr_size
            for j=1:i-1
                dept_flow = DF(i,j);
                site1 = AM(ant,i);
                site2 = AM(ant,j);
                if site1  site2
                    sites_distance = DF(site1, site2);
                else
                sites_distance = DF(site2, site1);
               end
            costs(ant) = costs(ant) + dept_flow * sites_distance;
            end
        end
        if costs(ant)  min_cost | min_cost==-1
        min_cost = costs(ant);
        ch_assign = AM(ant,:);
        end
        if mod(assign,100) == 0
        disp( sprintf('Assignments so far : % d Cheapest cost : % d', assign, min_cost));
        end
        assign = assign + 1;
    end
end
    disp( sprintf('Cheapest Cost : % d', min_cost));
    disp( sprintf('Assignments : % d', assign-1));
    disp(' ');
    disp('Assignment');
    disp('----------');
    ant_index = find(costs==min(costs));
    for i=1:pr_size
        disp( sprintf('Dept % d to Site % d', i, ch_assign(i)));
end
    