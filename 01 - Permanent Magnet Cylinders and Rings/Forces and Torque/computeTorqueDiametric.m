function T = computeTorqueDiametric(R1,R2,L1,L2,M1,M2,d) 

% void permeability
mu0  = 4*pi*1e-7;               % [T*m/A]

% residual magnetization
M1  = M1(:); 
M2  = M2(:);
R2a = R2/R1;
L1a = L1/R1;
L2a = L2/R1;
da  = d/R1;

zetaT = zetaTorqueFun(R2a,L1a,L2a,da);

T = mu0/6*R1^2*R2*zetaT*cross(M1,M2);