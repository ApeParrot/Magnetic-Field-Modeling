function eta = etaFun_stable(R2,x)

l   = ( sqrt( (1+R2).^2+x.^2 ) + sqrt( (1-R2).^2+x.^2 ) )/2;
f6 = fun6(R2,x);
f7 = fun7(R2,x);

eta = x./l.*(f6 - f7);

xTol = abs(x) < 1e-4;
R2Tol = abs(R2-1) < 1e-6;
eta(R2Tol & xTol) = 0;