function [res, Y, Hstar,obj] = EEOMVC_main(fea, numClust, gt, r1Temp, r2Temp, r3Temp, anc_idx, anc_allidx)

v = length(fea);
cfea = [];
index = anc_idx{r3Temp};
for i = 1 : v  
    fea_anch{i} = fea{i}(index(i,:),:);
    cfea = [fea{i}';cfea];
end
cfea = cfea';

allindex = anc_allidx{r3Temp};
fea_allanch = cfea(allindex,:);

sample_num = size(fea{1},1);
anch_num = size(index,2);
L0 = zeros(sample_num,anch_num);

HP = cell(1, v);
for t = 1 : v
    [Z{t},~] = AnchorGraph(fea{t}',fea_anch{t}',5);
    Z{t} = Z{t} + eps*eye(sample_num,anch_num);
     L{t} = Z{t} * diag(sum(Z{t},1))^(-1/2);
    [HP{t}, ~, ~] = mySVD(L{t},numClust); 
end
[L0,~] = AnchorGraph(cfea',fea_allanch',5);
L0 = L0 + eps*eye(sample_num,anch_num);

L1 = L0 * diag(sum(L0,1))^(-1/2);
[M, ~, ~] = mySVD(L1,numClust);

[Y,Hstar,obj] = one_step(HP,numClust,r1Temp,r2Temp,M);
 
[~,res_label] = max(Y,[],2);
res = zeros(2, 8);
res(1,:) = Clustering8Measure(gt, res_label);
end

