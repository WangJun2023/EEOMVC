function Y = update_Y(Y,Hstar,Q,sample_num,clus_num)
     G = Hstar * Q;
     yg = diag(Y'* G)';
     yy = diag(Y'*Y+eps*eye(clus_num))';
     for i = 1 : sample_num
         gi = G(i,:);
         yi = Y(i,:);
         si = (yg+gi.*(1-yi))./sqrt(yy+1-yi) - (yg-gi.*yi)./sqrt(yy-yi);
         [~,index] = max(si(:));
         Y(i,:) = 0;
         Y(i,index) = 1;
     end
end

