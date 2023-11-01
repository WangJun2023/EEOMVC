function Q = update_Q(Hstar,Y)
     A = Hstar' * Y * (Y'*Y+eps*eye(size(Y,2)))^(-0.5);
    [U,~,V] = svd(A,'econ');
    Q = U * V';
end

