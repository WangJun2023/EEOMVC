function Rv = update_Rv(gamma,HP,Hstar)
    view_num =length(HP); 
    for v = 1:view_num
        if gamma(v)>1e-4
            TP = gamma(v)*HP{v}'*(Hstar);
            [U,~,V] = svd(TP,'econ');
            Rv{v} = U * V';
        end  
    end

end

