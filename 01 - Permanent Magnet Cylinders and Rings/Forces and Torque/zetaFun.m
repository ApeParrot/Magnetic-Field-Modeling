function zeta = zetaFun(R2,x)

l   = ( sqrt( (1+R2)^2+x.^2 ) + sqrt( (1-R2)^2+x.^2 ) )/2;
f6 = fun6(R2,x);
f8 = fun8(R2,x);

zeta = 1./l.*( (2*(1+R2.^2)-x.^2).*f6 + f8 );