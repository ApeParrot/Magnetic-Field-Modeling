function T = dipdipTorque(p1,p2,m1v,m2v)

mu0 = 4*pi*1e-7;

% make sure all vectors are column-wise
p1 = p1(:);
p2 = p2(:);
m1v = m1v(:);
m2v = m2v(:);

rv  = p2-p1;
r   = norm(rv);
rv  = (r/rv)';

m1 = norm(m1v);
m1v = m1v/m1;

m2 = norm(m2v);
m2v = m2v/m2;

T = mu0*m1*m2/(4*pi*r^3)*( 3*(m1v'*rv)*cross(m2v,rv) + cross(m1v,m2v));