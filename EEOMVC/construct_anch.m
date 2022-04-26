function [U,S] = construct_anch(allSmp,anchor,k,c)
% Input:
%   allSmp -each row is a sample (n-by-d)
%   anchor -selected from allSmp (m-by-d)
%   k      -number of neighbors
% Output:
%   Z      -instance-to-anchor similarity matrix (n-by-m)
[n, ~] = size(allSmp);
[m, ~] = size(anchor);
Dist = EuDist2(allSmp,anchor,0); % Euclidean distance.^2
sigma = 0.5*mean(mean(Dist));% optional:4*mean(mean(Dist)); % optional: sigma = 10
[~, idx] = sort(Dist,2); % sort each row ascend
idx = idx(:,1:k); % default: self-connected
G = sparse(repmat([1:n]',[k,1]),idx(:),ones(numel(idx),1),n,m);
%%% the i_th row of matrix G stores the information of the  
%%% i_th sample's k neighbors. (1: is a neighbor, 0: is not)
Z = (exp(-Dist/sigma)).*G; % Gaussian kernel weight
Z = bsxfun(@rdivide,Z,sum(Z,2));
Z(Z<1e-5) = 0;
S = Z*diag(sum(Z,1))^(-1/2);
[U, ~, V] = mySVD(S,c);

% S = Z*diag(1./sum(Z,1))*Z';
% S = full(max(S,S')); % guarantee symmetry
end

