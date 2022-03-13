% Auxiliary function FUN2 to compute the magnetic field of a uniformly
% magnetized cylinder.
% 
% inputs: rho (adimensional radial coord.), z (adimensional axial coord.),
%         L (adimensional magnet half height), varargin (structure 
%         containing precomputed auxiliary variables, optional)
%
% In article notation:
%                    _                                  _ +
%                   |                                    |
% f2 = rho^(-3)/4 * | z_i/d_i * C(k_ci,1,1-2*rho,1+2*rho)|  -  f_Lambda
%                   |_                                  _|                       
%                                                         -
%
% Definition is provided in Table 1 - Working Definitions
% Such implementation has no external package dependency, it only requires
% the parallel implementation of the Bulirsch Algorithm, provided by the
% author.
%
% Author: Masiero Federico
% Last check: 16-02-2022

function f2 = fun2Parallel(rho,z,L,varargin)
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
% Matrix of ones
Ones = ones(size(z));

% thresholding to change expression (for numerical stability)
id1 = rho > 5e-4;      % In this case compute with the normal expression 
id2 = ~id1;            % use first order expansion for rho -> 0
f2  = zeros(size(z));

f2(id1) = rho(id1).^(-3)/4.*                                           ...
          ( zP(id1)./dP(id1).*BulirschCELParallel(kcP(id1), Ones(id1), ...
                                     1-2*rho(id1), 1+2*rho(id1),1e-8)  ...
          - zM(id1)./dM(id1).*BulirschCELParallel(kcM(id1), Ones(id1), ...
                                     1-2*rho(id1), 1+2*rho(id1),1e-8)  ...
          - fL(id1));

% Numerical chopping for rho -> 0, result of the limit of previous
% expression for rho -> 0. This chopping is engaged for points far 5e-4
% from the cylinder axis. Thus the implementation is quite stable.
% See Appendices B,C,D
f2(id2) =   rho(id2)*3/8.*(   zM(id2)./(zM(id2).^2+1).^(5/2)          ...
                            - zP(id2)./(zP(id2).^2+1).^(5/2) ) ; 