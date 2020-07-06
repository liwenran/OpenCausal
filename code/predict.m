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
%% predict openness score for each donor
%% Download from GTEx project
fid = fopen('GTEx_rnaseq.txt');
C = textscan(fid, '%s %*[^\n]');
fclose(fid);
Genes=C{1,1};

%%
fid = fopen('TFs_col.txt');
C = textscan(fid, '%s %*[^\n]');
fclose(fid);
TFs=C{1,1};

%%
[tfind,index1]=ismember(TFs,Genes);

%%var-level TFBS based on GTEx WGS 
TF_binding=dlmread('var_binding_count.txt','\t',0,0);
TF_binding=single(TF_binding(:,tfind)');

%%RE-level params
load('params.mat');
alpha=single(alpha);

%%var-level params
index=load('index_from_RE_to_var.tmp');
params=alpha(:,index);

%% GTEx expr data
% load TFexpr
GTEx_TFexpr=dlmread('TFexpr.txt','\t',0,1); % exprs of TFs for GTEx samples
GTEx_TFexpr=log2(GTEx_TFexpr+1);

%%var-level open scores
pred_var=params(1,:)'+full(((params(2:end,:).*TF_binding)'*GTEx_TFexpr)')';
save('pred_var_open_score.mat', 'pred_var','-v7.3');

