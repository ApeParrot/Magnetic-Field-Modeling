% Auxiliary function FUN1 to compute the magnetic field of a uniformly
% magnetized cylinder.
% 
% inputs: rho (adimensional radial coord.), z (adimensional axial coord.),
%         L (adimensional magnet half height), varargin (structure 
%         containing precomputed auxiliary variables, optional)
%
% In article notation:
%             _                      _ +
%            |                        |
% f1 = 1/4 * | z_i/d_i * C(k_ci,1,1,1)|  +  f_Lambda
%            |_                      _|                       
%                                      -
%
% Definition is provided in Table 1 - Working Definitions
% Such implementation has no external package dependency, it only requires
% the parallel implementation of the Bulirsch Algorithm, provided by the
% author.
%
% Author: Masiero Federico
% Last check: 16-02-2022

function f1 = fun1Parallel(rho,z,L,varargin)
% Notation in article: varP = var_+, varM = var_- 
% uses precomputed auxiliary variables
if size(varargin,1) == 1 
    % access the struct with the auxiliary variables
    auxVar = varargin{1};
    zP     = auxVar.zP;
    zM     = auxVar.zM;
    dP     = auxVar.dP;
    dM     = auxVar.dM;
    kcP    = auxVar.kcP;
    kcM    = auxVar.kcM;
    sigmaP = auxVar.sigmaP;
    sigmaM = auxVar.sigmaM;

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
    sigmaP = sqrt(zP.^2./((1-rho).^2+zP.^2));
    sigmaM = sqrt(zM.^2./((1-rho).^2+zM.^2));

% too many input arguments    
else
    error("Too many input arguments.")
end

% Compute f_Lambda
fL = fLambdaParallel(rho,z,L,[kcP kcM],[sigmaP sigmaM]);

% Matrix of ones.
Ones = ones(size(z));

f1 = 1/4*(  zP./dP.*BulirschCELParallel(kcP,Ones,Ones,Ones,1e-8) ... | jump operator
          - zM./dM.*BulirschCELParallel(kcM,Ones,Ones,Ones,1e-8) ... |
          + fL);