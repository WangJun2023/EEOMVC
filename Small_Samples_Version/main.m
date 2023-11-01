function [res,Y,Hstar,obj] = ours_main(fea, numClust, knn0, metric, gt, r1Temp, r2Temp)
   
WW = make_distance_matrix(fea, metric);
knn = knn0 + 1;
v = length(WW);
opts.maxit = 2000;
opts.fail = 'keep';
L = cell(1, v);
sample_num = size(fea{1},1);
L0 = zeros(sample_num,sample_num);
HP = cell(1, v);
cfea = [];

for t=1:v
    A = make_kNN_dist(WW{t}, knn);
    L{t} = normalizedLaplacian(A);  %% change from `L{i} = E - normalizedLaplacian(A);`
    [HP{t},~] = eigs(L{t}, numClust, 'la', opts);  %% change 'lm' to 'la'  
    cfea = [fea{t}';cfea];
%     L0 = L0 + 1/v * L{t};
end
cfeature{1} = cfea';
W0 = make_distance_matrix(cfeature, metric);
L0 = make_kNN_dist(W0{1}, knn);
L0 = normalizedLaplacian(L0);
[M,~] = eigs(L0, numClust, 'la', opts);

[Y,obj,Hstar] = one_step(HP,numClust,r1Temp,r2Temp,M);

 % [res_label, ~, ~, ~] = kmeans(Hstar,numClust,'maxiter',100,'replicates',50,'emptyaction','singleton');
 
[~,res_label] = max(Y,[],2);
res = zeros(2, 8);
res(1,:) = Clustering8Measure(gt, res_label);
end
