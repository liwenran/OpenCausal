function calculate_lamda(filename)

RE_index=dlmread(['RE_index_alldonors/',filename,'.RE_index'],'\t',0,3);
donor_index=dlmread('donors_for_lamda.txt','\t',0,3);
j=1;
for i=1:size(donor_index,1)
    D=donor_index(i,1);
    load(['pred_ref_open_donor_', num2str(D), '.mat']);
    col=donor_index(i,2);
    RE_open(:,j)=pred_RE_ref(RE_index,col);
    j=j+1;
end
size(RE_open)

%% from RE-level to variant-level, ref-open of donors without mutation
match_RE_var=dlmread(['match_RE_var/', filename,'.match_RE_var'],'\t',0,8);
ref_open=RE_open(match_RE_var,:);

%% var-open of donors with mutation
donor_index=dlmread('donors_for_lamda.txt','\t',0,3);
j=1;
for i=1:size(donor_index,1)
    D=donor_index(i,1);
    load(['pred_var_open_donor_', num2str(D), '.mat']);
	extract_index = dlmread(['temp/', filename, '.lamda_donorvar_index.donor', num2str(D)],'\t',0,8);
    col=donor_index(i,2);
    var_open(extract_index(:,2),j)=pred_var(extract_index(:,1),col);
    j=j+1;
end
size(var_open)

%% Mean of open scores of allele 1 (i.e.donors with mutation)
var_index=dlmread([filename,'.lamda_donor_info'],'\t',0,8);
mean_of_mutation=sum(var_open,2)./sum(var_index~=0,2); %Note: the order of donors for var_open is different from the orders of lamda_donor_info

%% Mean of open scores of allele 2 (i.e.donors without mutation)
%var_index=dlmread([filename,'.lamda_donor_info'],'\t',0,8);
mean_of_dismutation=sum(ref_open.*(var_index==0),2)./sum(var_index==0,2);

lamda=double(abs(mean_of_mutation-mean_of_dismutation));
save(['lamda_scores_var/', filename,'.lamda_scores_var'],'lamda','-ascii');

end

