function generate_trainset(N)

y=load('y/y_heights.txt');

m2=median(y);
m1=median(y(y<m2));
m3=median(y(y>m2));

idx=1:size(y,1);
idx1=idx(y<=m1);
idx2=idx(y>m1&y<=m2);
idx3=idx(y>m2&y<=m3);
idx4=idx(y>m3);

%seedn=size(y,1);

rng(N);
TestSet1=randsample(idx1,int32(size(idx1,2)/10));
TrainSet1=setdiff(idx1,TestSet1);

rng(N);
TestSet2=randsample(idx2,int32(size(idx2,2)/10));
TrainSet2=setdiff(idx2,TestSet2);

rng(N);
TestSet3=randsample(idx3,int32(size(idx3,2)/10));
TrainSet3=setdiff(idx3,TestSet3);

rng(N);
TestSet4=randsample(idx4,int32(size(idx4,2)/10));
TrainSet4=setdiff(idx4,TestSet4);

TestSet=[TestSet1,TestSet2,TestSet3,TestSet4];
TrainSet=[TrainSet1,TrainSet2,TrainSet3,TrainSet4];

save('y/training.mat','y','TestSet','TrainSet');

end

