pool=parpool('local',6,'IdleTimeout', 8000)

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%var-level TFBS based on GTEx WGS 
TF_binding=dlmread('var_binding_count.txt','\t',0,0);
TF_binding=single(TF_binding(:,tfind)');

%%var-level open scores
pred_var=params(1,:)'+full(((params(2:end,:).*TF_binding)'*GTEx_TFexpr)')';
save('pred_var_open_score.mat', 'pred_var','-v7.3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%var-level TFBS based on reference genome
TF_binding=dlmread('ref_binding_count.txt','\t',0,0);
TF_binding=single(TF_binding(:,tfind)');

%%var-level open scores
pred_ref=params(1,:)'+full(((params(2:end,:).*TF_binding)'*GTEx_TFexpr)')';
save('pred_ref_open_score.mat', 'pred_ref','-v7.3');
