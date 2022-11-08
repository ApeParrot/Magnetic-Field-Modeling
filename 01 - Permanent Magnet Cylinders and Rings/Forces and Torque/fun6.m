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
% Package Dependencies: funzioni di Elfun richieste <-------
%
% Author: Masiero Federico
% Last check: 18-12-2021

function f6 = fun6(R2,x)

l  = ( sqrt( (1+R2).^2+x.^2 ) + sqrt( (1-R2).^2+x.^2 ) )/2;
k  = R2./l.^2;
kc = sqrt(1-k.^2);

% Matrix of ones.
Ones = ones(size(x));
Zeros = 0*Ones;

f6 = k.*BulirschCEL(kc,Ones,Zeros,-Ones);