function F = computeForceAxial(R1,R2,L1,L2,M1,M2,d) 

% void permeability
mu0  = 4*pi*1e-7;               % [T*m/A]

% residual magnetization
M1   = M1(:); 
M2   = M2(:);

% adimensional coordinates
R2a = R2/R1;
L1a = L1/R1;
L2a = L2/R1;
da  = d/R1;

etaF = etaForceFun(R2a,L1a,L2a,da);

F = -mu0*R1*R2*etaF*M1'*M2;