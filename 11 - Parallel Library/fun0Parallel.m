% Auxiliary function FUN0 to compute the magnetic field of a uniformly
% magnetized cylinder.
% 
% inputs: rho (adimensional radial coord.), z (adimensional axial coord.),
%         L (adimensional magnet half height)
%
% f0 = 0    outside the magnet, i.e. abs(z) > L | ( abs(z) < L & rho > 1 ) 
%    = -pi  inside the magnet,  i.e. abs(z) < L & rho < 1
%
% Author: Masiero Federico
% Last check: 18-12-2021

function f0 = fun0Parallel(rho,z,L)
% generate matrix of zeros with the data point size
f0 = zeros(size(rho));
% overwrite values inside the magnet volume (uses heaviside)
f0(abs(z) < L) = -pi*heaviside(1-rho(abs(z) < L));