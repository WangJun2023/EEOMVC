function Y = initial_Y(num_sample, num_cluster)
I = eye(num_cluster);
% K = 1:num_cluster;
K = num_cluster: - 1: 1;
g = ceil(num_sample/num_cluster);
inG0 = repmat(I(K,:),g,1);
Y = inG0(1:num_sample,:);
end

