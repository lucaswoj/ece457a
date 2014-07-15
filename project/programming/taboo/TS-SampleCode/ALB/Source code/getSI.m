function SI=getSI(seq,tasktime,cycle_time)
intial=seq;
NS=0;
workload_mat=[];
workload=0;
ws=[];
worktime_station=[];
ct=cycle_time;
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