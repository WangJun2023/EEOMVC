function  Hstar = update_Hstar(Z, lambda, M, beta, Y, Q)
    S = Z + lambda * M + 2 * beta * Y * (Y'*Y+eps*eye(size(Y,2)))^(-0.5) * Q';
    [U,~,V] = svd(S,'econ');
    Hstar = U * V';
end