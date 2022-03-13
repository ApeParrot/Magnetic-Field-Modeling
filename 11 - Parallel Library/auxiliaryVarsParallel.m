% Function to compute the auxiliary parameters involved in the computation
% of the Bulirsch integral Cel and the Normalized Heuman's Lambda Function.
%
% Definition is provided in Table 1 - Working Definitions
%
% Author: Masiero Federico
% Last check: 16-02-2022

function vars = auxiliaryVarsParallel(rho,z,L)

vars.zP     = z+L;
vars.zM     = z-L;
vars.dP     = sqrt((1+rho).^2 + vars.zP.^2);
vars.dM     = sqrt((1+rho).^2 + vars.zM.^2);
vars.kP     = sqrt(4*rho./vars.dP.^2);
vars.kM     = sqrt(4*rho./vars.dM.^2);
vars.kcP    = sqrt(1-vars.kP.^2);
vars.kcM    = sqrt(1-vars.kM.^2);
vars.sigmaP = sqrt(vars.zP.^2./((1-rho).^2+vars.zP.^2));
vars.sigmaM = sqrt(vars.zM.^2./((1-rho).^2+vars.zM.^2));