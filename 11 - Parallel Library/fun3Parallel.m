% Auxiliary function FUN3 to compute the magnetic field and magnetic field
% gradient of a uniformly magnetized cylinder.
% 
% inputs: rho (adimensional radial coord.), z (adimensional axial coord.),
%         L (adimensional magnet half height), varargin (structure 
%         containing precomputed auxiliary variables, optional)
%
% In article notation:
%           _                                                  _ +
%          |                                                    |
% f3 = 4 * | 1/d_i^3 * C(2*sqrt(k_ci)/(1+k_ci),1,0,2/(1+k_ci)^3)|
%          |_                                                  _|                       
%                                                                -
% Definition is provided in Table 1 - Working Definitions
% Such implementation has no external package dependency, it only requires
% the parallel implementation of the Bulirsch Algorithm, provided by the
% author.
%
% Author: Masiero Federico
% Last check: 16-02-2022

function f3 = fun3Parallel(rho,z,L,varargin)
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

Ones  = ones(size(z));
Zeros = Ones*0;

f3 = 4*( (1./dP.^3).*BulirschCELParallel(2*sqrt(kcP)./(1+kcP), Ones,  ...
                                 Zeros               , 2./(1+kcP).^3,1e-8) ...
       - (1./dM.^3).*BulirschCELParallel(2*sqrt(kcM)./(1+kcM), Ones,  ...
                                 Zeros               , 2./(1+kcM).^3,1e-8) );