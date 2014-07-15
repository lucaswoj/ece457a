function [neighbor_mat, seq_mat]=neighbor(pred_mat,seq)

neighbor_mat=[];
seq_mat=[];
for iix=1:size(seq,2)
    xx=seq(1,iix);
    followers=find(pred_mat(:,xx)==1);
    aa_mat=[];
    if size(followers,1)>=1
    for iia=1:size(followers,2)
    aa=find(seq(1,:)==followers(iia,1));
    aa_mat=[aa_mat aa];
    end
    sss=min(aa_mat);
    else
        sss=size(seq,2)+1;
    end
    for iiy=iix+1:sss-1
    yy=seq(1,iiy);
    if pred_mat(xx,yy)<1
neighbor_mat=[neighbor_mat;xx yy];
seq_1=seq(1,1:iix-1);
seq_2=seq(1,iix+1:iiy);
seq_3=seq(1,iiy+1:end);
new_seq=[seq_1 seq_2 xx seq_3];
seq_mat=[seq_mat;new_seq];

    end
    end
end