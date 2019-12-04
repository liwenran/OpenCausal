function regression(num_cv, filename) 
generate_trainset(num_cv)
data=load(['x/',filename]);
data=data(sum(data')>0,:);
load('y/training.mat'); %y,TrainSet,TestSet


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Prediction using 50 variants
%TOP
y1=y(TrainSet,:);
X1=data(1:50,TrainSet)';
[beta FitInfo]=lasso(X1,y1,'CV',5,'Alpha',0.5);
Aalpha=[FitInfo.Intercept(FitInfo.IndexMinMSE);beta(:,FitInfo.IndexMinMSE)];

y2=y(TestSet,:);
X2=data(1:50,TestSet)';
y2_pred=(Aalpha(1)+Aalpha(2:end)'*X2')';

pcc=corr(y2,y2_pred)
r2_50_top=pcc.^2

%BOTTOM
y1=y(TrainSet,:);
X1=data(size(data,1)-50+1:end,TrainSet)';
[beta FitInfo]=lasso(X1,y1,'CV',5,'Alpha',0.5);
Aalpha=[FitInfo.Intercept(FitInfo.IndexMinMSE);beta(:,FitInfo.IndexMinMSE)];

y2=y(TestSet,:);
X2=data(size(data,1)-50+1:end,TestSet)';
y2_pred=(Aalpha(1)+Aalpha(2:end)'*X2')';

pcc=corr(y2,y2_pred)
r2_50_tail=pcc.^2


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Prediction using ALL variants
y1=y(TrainSet,:);
X1=data(:,TrainSet)';
[beta FitInfo]=lasso(X1,y1,'CV',5,'Alpha',0.5);
Aalpha=[FitInfo.Intercept(FitInfo.IndexMinMSE);beta(:,FitInfo.IndexMinMSE)];

y2=y(TestSet,:);
X2=data(:,TestSet)';
y2_pred=(Aalpha(1)+Aalpha(2:end)'*X2')';

pcc=corr(y2,y2_pred)
r2_all=pcc.^2

r2 = [r2_50_top, r2_50_tail, r2_100_top, r2_100_tail, r2_all];
save(['r2/',filename,'.r2'],'r2','-ascii');

end



