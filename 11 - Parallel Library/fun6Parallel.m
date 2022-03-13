% Auxiliary function FUN6 to compute the magnetic force and torque between
% coaxial magnetized cylinders.
% 
% inputs: rho (adimensional radial coord.), z (adimensional axial coord.),
%         L (adimensional magnet half height), varargin (structure 
%         containing precomputed auxiliary variables, optional)
%
% In article notation:
%
% f6 = k * C(k_c,1,0,-1)|  
%                              
% Definition is provided in Table 4 - Results Force and Torque between
% coaxial magnets
% Such implementation has no external package dependency, it only requires
% the parallel implementation of the Bulirsch Algorithm, provided by the
% author.
%
% Author: Masiero Federico
% Last check: 16-02-2022

function f6 = fun6Parallel(R2,x)

l  = ( sqrt( (1+R2).^2+x.^2 ) + sqrt( (1-R2).^2+x.^2 ) )/2;
k  = R2./l.^2;
kc = sqrt(1-k.^2);

% Matrix of ones.
Ones = ones(size(x));
Zeros = 0*Ones;

f6 = k.*BulirschCELParallel(kc,Ones,Zeros,-Ones);