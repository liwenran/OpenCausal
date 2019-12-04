pool=parpool('local',6,'IdleTimeout', 8000)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%loading training data (Download from ENCODE project)
expr=dlmread('ENCODE_expr.txt','\t',0,1);
expr=log2(expr+1);

fid = fopen('ENCODE_expr.txt');
C = textscan(fid, '%s %*[^\n]');
fclose(fid);
Genes=C{1,1};

%%
fid = fopen('TFs_col.txt');
C = textscan(fid, '%s %*[^\n]');
fclose(fid);
TFs=C{1,1};

[tfind,index]=ismember(TFs,Genes);
TFexpr=expr(index(index>0),);

%%
TF_binding=dlmread('RE_binding_count.txt','\t',0,0);
TF_binding=TF_binding(:,tfind)';
%TF_binding(TF_binding>0)=1;

%%
Open=dlmread('ENCODE_open.bed','\t',0,3);
Open=log2(1+Open);

%%
N=size(Open,1);

%training
parfor i=1:N
    y=Open(i,:)';
    X=full((TF_binding(:,i).*TFexpr)');
    [beta FitInfo]=lasso(X,y,'CV',5,'Alpha',0.5);
    alpha(:,i)=[FitInfo.Intercept(FitInfo.IndexMinMSE);beta(:,FitInfo.IndexMinMSE)];
end

save('params.mat', 'alpha','-v7.3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GTEx data
Ens_expr=dlmread('GTEx_rnaseq.txt','\t',0,1);
Ens_expr=log2(Ens_expr+1);

fid = fopen('GTEx_rnaseq.txt');
C = textscan(fid, '%s %*[^\n]');
fclose(fid);
Ens_genes=C{1,1};

[tfind,index]=ismember(TFs,Ens_genes);
GTEx_TFexpr=Ens_expr(index(index>0),:);

%%predict GTEx
%load('params_TFexpr.mat')
GTEx_Open=alpha(1,1:N)'+full(((alpha(2:end,1:N).*TF_binding)'*GTEx_TFexpr)')';
save('pred_GTEx_open.mat', 'GTEx_Open','-v7.3');
