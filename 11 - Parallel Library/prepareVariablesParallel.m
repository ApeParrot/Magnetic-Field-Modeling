function [rho,phi,z,L,p,u,v,c,s] = prepareVariablesParallel(...
                                                    xM,yM,zM,O,...
                                                    e_par,e_bot,...
                                                    M_par,M_bot,...
                                                    L,R)

% distance vectors from magnet center to points of interest
x   = xM(:)-O(1);
y   = yM(:)-O(2);
z   = zM(:)-O(3);

phi = atan2(y,x);

% adimensional distance vector (P-O)/R in matrix form
p   = [x y z]/R;

% make unit vectors and their magnetization vectors as 1D column array
e_par = e_par(:); e_bot = e_bot(:);
M_par = M_par(:); M_bot = M_bot(:);

% prepare matrices for vector computation
e_par_Mat = repmat(e_par',size(p,1),1);
e_bot_Mat = repmat(e_bot',size(p,1),1);
M_par_Mat = repmat(M_par',size(p,1),1);
M_bot_Mat = repmat(M_bot',size(p,1),1);

% local cilindrical coordinates
rho = vecnorm(cross(p,e_par_Mat),2,2);
z_L = dot(p,e_par_Mat,2);

% numerical threshold
th = eps;
onAxis = rho <= th;

nu = cross(p,e_par_Mat)./rho;

e_aux_Mat = cross(e_par_Mat,e_bot_Mat);

% reflection (valid out of magnet axis)
c = dot(p,e_bot_Mat,2)./rho;
s = dot(p,e_aux_Mat,2)./rho;

% correct values on axis
if sum(onAxis) > 0
    rho(onAxis)  = 0;
    c(onAxis)    = 0;
    s(onAxis)    = 0;
    nu(onAxis,:) = 0;
end

% projection
v = dot(p,M_par_Mat-M_bot_Mat,2).*e_par_Mat - norm(M_par)*p;
u = rho.*(M_bot_Mat-2*dot(M_bot_Mat,nu,2).*nu);

L = L/R;
z = z_L;