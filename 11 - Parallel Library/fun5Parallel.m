% Auxiliary function FUN5 to compute the magnetic field gradient of a 
% uniformly magnetized cylinder.
% 
% inputs: rho (adimensional radial coord.), z (adimensional axial coord.),
%         L (adimensional magnet half height), varargin (structure 
%         containing precomputed auxiliary variables, optional)
%
% In article notation:
%       _                                       _ +
%      |                                         |
% f5 = | 1/d_i^3 * C(k_ci,1,(1-rho)/k_ci^2,1+rho)| 
%      |_                                       _|                       
%                                                 -
%
% Definition is provided in Table 1 - Working Definitions
% Such implementation has no external package dependency, it only requires
% the parallel implementation of the Bulirsch Algorithm, provided by the
% author.
%
% Author: Masiero Federico
% Last check: 16-02-2022

function f5 = fun5Parallel(rho,z,L,varargin)
% Notation in article: varP = var_+, varM = var_- 
% uses precomputed auxiliary variables
if size(varargin,1) == 1 
    % access the struct with the auxiliary variables
    auxVar = varargin{1};
    dP     = auxVar.dP;
    dM     = auxVar.dM;
    kcP    = auxVar.kcP;
    kcM    = auxVar.kcM;

% no auxiliary variables available -> compute those from scratch
% see tables of definition in paper
elseif size(varargin,1) == 0
    zP     = z+L;
    zM     = z-L;
    dP     = sqrt((1+rho).^2 + zP.^2);
    dM     = sqrt((1+rho).^2 + zM.^2);
    kP     = sqrt(4*rho./dP.^2);
    kM     = sqrt(4*rho./dM.^2);
    kcP    = sqrt(1-kP.^2);
    kcM    = sqrt(1-kM.^2);

% too many input arguments    
else
    error("Too many input arguments.")
end

Ones = ones(size(z));

f5 =   1./dP.^3.*BulirschCELParallel(kcP,Ones,(1-rho)./kcP.^2,1+rho,1e-8) ...
     - 1./dM.^3.*BulirschCELParallel(kcM,Ones,(1-rho)./kcM.^2,1+rho,1e-8);