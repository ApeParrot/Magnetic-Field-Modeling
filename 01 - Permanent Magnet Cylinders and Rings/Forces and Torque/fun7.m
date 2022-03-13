% Auxiliary function FUN7 to compute the magnetic force and torque between
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
% Package Dependencies: funzioni di Elfun richieste <-------
%
% Author: Masiero Federico
% Last check: 18-12-2021

function f7 = fun7(R2,x)

l   = ( sqrt( (1+R2).^2+x.^2 ) + sqrt( (1-R2).^2+x.^2 ) )/2;
m   = ones(size(x));
M   = m;
m(m>R2) = R2(m>R2);
M(m<R2) = R2(m<R2);

csi = m./M;
k   = R2./l.^2;
kc  = sqrt(1-k.^2);

f7 = BulirschCEL(kc,1-csi.*k,csi,csi-k);