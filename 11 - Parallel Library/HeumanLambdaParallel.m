function lambda = HeumanLambdaParallel(beta,k,Tol)    

m = k.^2;

lambda = 2*beta/pi;

x = mod(beta(m ~= 1),pi/2);

t = 1 - m(m ~= 1);
p = 1 + m(m ~= 1).*(tan(x)).^2;
x = sin(x).*sqrt(p)./(pi/2);
t = BulirschCELParallel(sqrt(t), p, ones(size(t)), t, Tol);

lambda(m ~= 1) = t.*x;
lambda(beta == pi/2) = 1;