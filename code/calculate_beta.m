function calculate_beta(filename)
RE_index=dlmread(['RE_index_alldonors/', filename,'.RE_index'],'\t',0,3);
donor_index=dlmread('donors_for_beta.txt','\t',0,3);
j=1;
for i=1:size(donor_index,1)
    D=donor_index(i,1);
    load(['pred_ref_open_donor_', num2str(D), '.mat']);
    col=donor_index(i,2);
    RE_open(:,j)=pred_RE_ref(RE_index,col);
    j=j+1;
end
size(RE_open)

data=dlmread('donors_for_beta.txt','\t',0,1);
ht=data(:,1);
sex=data(:,2);
X=[RE_open;sex']';
[beta,~,~,~,stats]=regress(ht,X);
stats

%% from RE-level to variant-level, beta scores for each variant
match_RE_var=dlmread([filename,'.match_RE_var'],'\t',0,8);
var_beta=abs(beta(match_RE_var,:));
save(['beta_scores_var/', filename,'.beta_scores_var'],'var_beta','-ascii');

end

