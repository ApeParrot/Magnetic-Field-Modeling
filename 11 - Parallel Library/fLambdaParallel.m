% Auxiliary function FLAMBDA to compute the magnetic field gradient of a 
% uniformly magnetized cylinder.
% 
% inputs: rho (adimensional radial coord.), z (adimensional axial coord.),
%         L (adimensional magnet half height), varargin (structure 
%         containing precomputed auxiliary variables, optional)
%
% In article notation:
%       
% fLambda =   sign(1-rho)*(Lambda(sigma_+,k_+) - Lambda(sigma_-,k_-)) 
%             sign(1-rho)*(Lambda(sigma_+,k_+) + Lambda(sigma_-,k_-))
%           - sign(1-rho)*(Lambda(sigma_+,k_+) - Lambda(sigma_-,k_-))                      
%
% where Lambda(sigma_+,k_+) is the normalized Heuman's Lambdal.
%
% Definition is provided in Table 1 - Working Definitions
% Such implementation has no external package dependency, it only requires
% the parallel implementation of the Bulirsch Algorithm, provided by the
% author.
%
% Author: Masiero Federico
% Last check: 16-02-2022

function fL = fLambdaParallel(rho,z,L,kc,sigma)

kcP    = kc(:,1);
kcM    = kc(:,2);
sigmaP = sigma(:,1);
sigmaM = sigma(:,2);
betaP  = asin(sigmaP);
betaM  = asin(sigmaM);

fL     = zeros(size(kcP));

id1 = abs(z) > L; id2 = ~id1;

% id1 = true -> cases 1 and 3, i.e., z > L & z < -L 
fL(id1) = ( pi/2*HeumanLambdaParallel( betaP(id1),                   ...
                                       sqrt(1-kcP(id1).^2),1e-8 )    ...
          - pi/2*HeumanLambdaParallel( betaM(id1),                   ...
                                       sqrt(1-kcM(id1).^2),1e-8 ) ).*sign(z(id1)); 
% id2 = true -> case 2, i.e., |z| <= L
fL(id2) =   pi/2*HeumanLambdaParallel( betaP(id2),                   ...
                                       sqrt(1-kcP(id2).^2),1e-8 )    ...
          + pi/2*HeumanLambdaParallel( betaM(id2),                   ...
                                       sqrt(1-kcM(id2).^2),1e-8 );

fL = fL.*sign(1-rho);