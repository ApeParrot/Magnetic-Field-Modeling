function zetaT = zetaTorqueFun(R2,L1,L2,d)

zetaT =  zetaFun(R2,d+L1+L2) + zetaFun(R2,d-L1-L2) + ...
       - zetaFun(R2,d-L1+L2) - zetaFun(R2,d+L1-L2);