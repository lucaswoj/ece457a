function initial_seq =initial_solution(p_mat)
 initial_seq=[];
 while size(p_mat,1)>1;
cand=[];
  for xx=1:length(p_mat)-1;
     sumrow=sum(p_mat(xx+1 ,2:end));
    if sumrow==0;
        cand=[cand p_mat(1,xx+1)];
    end
  end
    y=ceil(rand*size(cand,2));
    initial_seq=[initial_seq cand(y)];
    p_mat(:,find(p_mat(1,:)==cand(y)))=[];
    p_mat(find(p_mat(:,1)==cand(y)),:)=[];
 end