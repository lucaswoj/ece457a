clc
clear all
close all
[cycle_time, precedence_mat, tasktime]=input_24();
TabuLength = 15;
NumIterations = 300;
%no_runs=10;
%final_seq=zeros(no_runs,1);
%for run_counter=1:no_runs
    %seq=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
    seq =initial_solution(precedence_mat);
    tabu_matrix=zeros(24,24);
    no_iteration=zeros(24,1);
    iteration_SI=zeros(24,1);
 
for n=1:NumIterations
    current_SI=getSI(seq,tasktime,cycle_time);
    [neighbor_mat, seq_mat]=neighbor(precedence_mat,seq);
    [best_seq,SI_best_move,i,j] = stations(cycle_time,seq_mat,tasktime,neighbor_mat,tabu_matrix);
    seq=best_seq;
    %Add new swap To Tabu Matrix
    tabu_matrix(i,j)=TabuLength;
    tabu_matrix(j,i)=TabuLength;
    %update the Tabu Matrix
    tabu_matrix = tabu_matrix - 1;
    tabu_matrix(tabu_matrix<0) = 0;
    %Plotting
    no_iteration(n)=n;
    iteration_SI(n)=current_SI;
end
%figure(run_counter);
plot(no_iteration,iteration_SI);
set(gcf,'color','w');
xlabel('Number Of Iteration');
ylabel('Best SI');
title('Tabu Length of 5');
seq
current_SI

%%%%%%%%%%%%%%%%%%%%%%%%%% For Multiple Runs%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%run(run_counter)=run_counter;
%final_SI(run_counter)=current_SI;
%end
%plotting the average of all runs
% figure(run_counter+1)
% plot(run,final_SI)
% xlabel('Run');
% ylabel('Final Acquired SI');
% title('Final SI Vs. Run');
% run
% final_SI
% average=mean(final_SI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
