% Auxiliary function FUN8 to compute the magnetic force and torque between
% coaxial magnetized cylinders.
% 
% inputs: rho (adimensional radial coord.), z (adimensional axial coord.),
%         L (adimensional magnet half height), varargin (structure 
%         containing precomputed auxiliary variables, optional)
%
% In article notation:
%
% f6 = C(k_c,1-csi*k,csi,csi-k)|  
%                              
% Definition is provided in Table 4 - Results Force and Torque between
% coaxial magnets
% Such implementation has no external package dependency, it only requires
% the parallel implementation of the Bulirsch Algorithm, provided by the
% author.
%
% Author: Masiero Federico
% Last check: 16-02-2022

function f8 = fun8Parallel(R2,x)

l   = ( sqrt( (1+R2).^2+x.^2 ) + sqrt( (1-R2).^2+x.^2 ) )/2;
m   = ones(size(x));
M   = m;
m(m>R2) = R2(m>R2);
M(m<R2) = R2(m<R2);

csi = m./M;
k   = R2./l.^2;
kc  = sqrt(1-k.^2);

f8 = BulirschCELParallel(kc,1-csi.*k,4.*R2 + 3*csi.*x.^2,...
                             4.*R2 + 3*csi.*x.^2 - k.*(4*csi.*R2+3*x.^2));