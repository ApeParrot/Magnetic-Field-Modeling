function H = computeFieldLocalization(R,L,M,magPos,points) 

% origin and reference frame of the cylinder
O     = magPos(1:3)';
e_par = magPos(4:6)';

% residual magnetization
M_par = M*e_par;

% Array of points of interest should be provided as an N x 3 matrix
if size(points,2) ~= 3
    points = points';
end

x = points(:,1);
y = points(:,2);
z = points(:,3);
[rho,z,L,p,v,~,~] = prepareVariablesLocalization(x,y,z,O,...
                                                 e_par,M_par,...
                                                 L,R);

vars  = auxiliaryVarsLocalization(rho,z,L);

% Field computation in coordinate free representation Eq.(13)
% outside the magnet for purely axial magnetization
f1 = fun1Localization(rho,z,L,vars);
f3 = fun3Localization(rho,z,L,vars);

M_par = repmat(M_par',size(p,1),1);
f1    = repmat(f1,1,size(p,2));
f3    = repmat(f3,1,size(p,2));

H  = 1/pi*( 2*f1.*M_par + f3.*v );