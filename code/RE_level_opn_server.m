%Calculate RE-level open scores
%O_RE = O_RE_ref + sigma(O_var_WGS-O_var_REF)

    idx=dlmread('RE_idx','\t');
    load('pred_var_open_score.mat')
    load('pred_ref_open_score.mat')
    if exist('pred_ref')*exist('pred_var')==1
    [REid,ia,ic]=unique(idx);
    n = accumarray(ic,1);
    RE_ref=pred_ref(ia,:);
    clear RE_sum
    for i=1:size(pred_var,2)
    RE_sum(:,i)=accumarray(ic,pred_var(:,i),[],@sum);
    end
    RE_opn=RE_sum-(n-1).*RE_ref;
    RE_opn(RE_opn<0)=0;
    save('pred_var_open_RELevel.mat','RE_opn','REid')
    clear pred_ref pred_var
    
