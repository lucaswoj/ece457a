function [best_seq, move_SI,i,j] = stations(cycle_time,seq_mat,tasktime,neighbor_mat,tabu_matrix)
solution=[];
worktime_station=[];
ct=cycle_time;

for iia=1:size(seq_mat,1)
    intial=seq_mat(iia,:);
NS=0;
workload_mat=[];
workload=0;
ws=[];

for i=1:size(intial,2)
    xx=intial(1,i);
    task_time=tasktime(2,xx);
    
if workload+task_time<=ct
    ws=[ws xx];
    workload=workload+task_time;
    
else
    NS=NS+1;
    workload_mat=[workload_mat workload];
     worktime_station=[worktime_station;ws zeros(1,size(tasktime,2)-size(ws,2))];
   
    workload=task_time;
    ws=[xx];
end
end
if size(ws,2)>0
     NS=NS+1;
     worktime_station=[worktime_station;ws zeros(1,size(tasktime,2)-size(ws,2))];
     workload_mat=[workload_mat workload];

end
wl_max=max(workload_mat);
wl_dev=0;
for aax=1:size(workload_mat,2)
    wl_max=max(workload_mat);
    wl_dev=wl_dev+(wl_max-workload_mat(1,aax))^2;
end
  SI=(wl_dev/NS)^(1/2);
 solution=[solution; neighbor_mat(iia,:) NS wl_max SI];
 
end
% Get the best SI and decide the move which yields it
least_SI=100;
for counter=1:size(solution,1)
    i=solution(counter,1);
    j=solution(counter,2);
    if (solution(counter,5)<least_SI && tabu_matrix(i,j)==0 && tabu_matrix(j,i)==0)
        least_SI=solution(counter,5);
        least_SI_position=counter;
    end
end


% best_move=[solution(least_SI_position,1) solution(least_SI_position,2)];
% move_SI=solution(least_SI_position,5);

% Randomizing the pick

for counter=1:size(solution,1)
    i=solution(counter,1);
    j=solution(counter,2);
    if(solution(counter,5)==least_SI && tabu_matrix(i,j)==0 && tabu_matrix(j,i)==0)
        least_SI_matrix=[counter solution(counter,1) solution(counter,2) solution(counter,5)];
    end
end
random_best=randi(size(least_SI_matrix,1));
counter_selected_sol=least_SI_matrix(random_best,1);
best_seq=seq_mat(counter_selected_sol,:);
i=solution(counter_selected_sol,1);
j=solution(counter_selected_sol,2);
move_SI=least_SI_matrix(random_best,4);


