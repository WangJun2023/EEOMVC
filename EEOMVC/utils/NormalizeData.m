function [X] = NormalizeData(X)
num = size(X{1},1); % number of instances
m = length(X); % number of views
%% Normalization: Z-score
for i = 1:m
    X{i} = full(X{i});
    for  j = 1:num
        normItem = std(X{i}(j, :));
        if (0 == normItem)
            normItem = eps;
        end
        X{i}(j, :) = (X{i}(j, :)-mean(X{i}(j, :)))/(normItem);
    end
end