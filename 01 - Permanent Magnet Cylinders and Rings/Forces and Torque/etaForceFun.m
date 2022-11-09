function etaF = etaForceFun(R2,L1,L2,d)

% etaF =   etaFun(R2,d+L1+L2) + etaFun(R2,d-L1-L2) + ...
%        - etaFun(R2,d-L1+L2) - etaFun(R2,d+L1-L2);

etaF =   etaFun_stable(R2,d+L1+L2) + etaFun_stable(R2,d-L1-L2) + ...
       - etaFun_stable(R2,d-L1+L2) - etaFun_stable(R2,d+L1-L2);