function  gamma = update_gamma(Hstar,HP,Rv)
    view_num = length(HP);
    coef = zeros(1,view_num);
    for v=1:view_num
        coef(1,v) = trace((Hstar)'*HP{v}* Rv{v});
    end
    gamma = coef/norm(coef,2);
end

