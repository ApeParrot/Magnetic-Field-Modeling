function F = dipdipForce(p1,p2,m1v,m2v)

mu0 = 4*pi*1e-7;

rv  = p2-p1;
r   = norm(rv);
rv  = r/rv;

% make sure all vectors are column-wise
m1v = m1v(:);
m2v = m2v(:);
rv  = rv(:);

m1 = norm(m1v);
m1v = m1v/m1;

m2 = norm(m2v);
m2v = m2v/m2;

F = 3*mu0*m1*m2/(4*pi*r^4)*( (m1v'*rv)*m2v + (m2v'*rv)*m1v + ...
                             (m1v'*m2v)*rv - 5*(m1v'*rv)*(m2v'*rv)*rv );