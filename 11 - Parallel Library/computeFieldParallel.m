function H = computeFieldParallel(R,L,Mstar,O,e_par,e_bot,points) 

% center and reference frame vectors of the cylinder recasted as 1D column
% vectors
O = O(:);
e_par = e_par(:);
e_bot = e_bot(:);

% residual magnetization
Mstar = Mstar(:);             % make this as a column vector
M_p   = (Mstar'*e_par);
M_b   = (Mstar'*e_bot);
M_par = M_p*e_par;
M_bot = M_b*e_bot;

% Array of points of interest should be provided as an N x 3 matrix
if size(points,2) ~= 3
    points = points';
end

x = points(:,1);
y = points(:,2);
z = points(:,3);
[rho,~,z,L,p,u,v,~,~] = prepareVariablesParallel(x,y,z,O,...
                                                 e_par,e_bot,...
                                                 M_par,M_bot,...
                                                 L,R);

vars  = auxiliaryVarsParallel(rho,z,L);

% Field computation in coordinate free representation Eq.(13)
f0 = fun0Parallel(rho,z,L);
f1 = fun1Parallel(rho,z,L,vars);
f2 = fun2Parallel(rho,z,L,vars);
f3 = fun3Parallel(rho,z,L,vars);

M_par = repmat(M_par',size(p,1),1);
M_bot = repmat(M_bot',size(p,1),1);

H  = 1/pi*( f0.*M_par + f1.*(2*M_par - M_bot) + f2.*u + f3.*v );