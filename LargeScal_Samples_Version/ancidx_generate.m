function [anc_idx,anc_allidx] = ancidx_generate(fea,gt)

r3 = [floor(size(gt,1) * 0.02),floor(size(gt,1) * 0.04),floor(size(gt,1) * 0.06),floor(size(gt,1) * 0.08)];
cfea = [];
for i = 1 : length(fea)
    cfea = [fea{i}';cfea];
end
for num = 1 : length(r3)
    anch_num = r3(num);
    v = length(fea);
    stream = RandStream.getGlobalStream;
    reset(stream);
    for i = 1 : v
        [label, center, bCon, sumD, D] = litekmeans(fea{i}, anch_num,'MaxIter', 50,'Replicates',5);
        [value,index] = sort(D,1);
        anc_idx{num}(i,:) = index(1,:);
    end
    [label, center, bCon, sumD, D] = litekmeans(cfea', anch_num,'MaxIter', 50,'Replicates',5);
    [value,index] = sort(D,1);
    anc_allidx{num} = index(1,:);
end

end

