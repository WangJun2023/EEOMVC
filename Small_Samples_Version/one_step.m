function [Y,obj,Hstar] = one_step(HP,clus_num,lambda,beta,M)
sample_num = size(HP{1}, 1); 
view_num = length(HP); 
maxIter = 100;
Q = eye(clus_num,clus_num);

% Ik = eye(clus_num);
% randorder = randperm(size(Ik,1));
% numceil = ceil(sample_num/clus_num);
% largeY = repmat(Ik(randorder,:),numceil,1);
% Y = largeY(1:sample_num,:); 


stream = RandStream.getGlobalStream;
reset(stream);
label = kmeans(M,clus_num,'maxiter',1000,'replicates',50,'emptyaction','singleton');

I = eye(max(label));
Y = I(label,:);

% Y = initial_Y(sample_num, clus_num);
    
gamma = ones(view_num,1)/(view_num);
Rv = cell(1,view_num);
for v = 1:view_num 
    temp_matrix = eye(clus_num);
    Rv{v} = temp_matrix;
end
flag = 1;
iter = 0;

while flag
    iter = iter + 1;
    Z = zeros(sample_num,clus_num);
    for v = 1:view_num
        Z = Z + gamma(v)*(HP{v}*Rv{v});
    end
    
    Hstar = update_Hstar(Z, lambda, M, beta, Y, Q);
    Rv = update_Rv(gamma,HP,Hstar);
    gamma = update_gamma(Hstar,HP,Rv);
    Q = update_Q(Hstar,Y);
    Y = update_Y(Y,Hstar,Q,sample_num,clus_num);
    
    temp = zeros(sample_num,clus_num);
    for v = 1 : view_num
        temp = temp + gamma(v)*(HP{v}*Rv{v});
    end
    obj(iter) = trace(Hstar'*temp + lambda*Hstar'*M + 2*beta*Hstar'*Y*(Y'*Y)^(-0.5)*Q');
    
    if (iter>2) && (abs((obj(iter-1)-obj(iter))/(obj(iter-1)))<1e-6 || iter>maxIter)
       flag =0;
    end
end
