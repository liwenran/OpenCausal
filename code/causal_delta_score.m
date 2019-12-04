function causal_delta_score(tissue)
%%
    pred_ref=load([tissue,'/ref/pred_GTEx_open.mat']);
    pred_var=load([tissue,'/var/pred_GTEx_open.mat']);
    delta=abs(log2(pred_var./pred_ref));
	delta(delta==Inf)=0;
	delta(isnan(delta))=0;
    save(['causal_score_', tissue, '.txt'], 'delta','-ascii');
end
