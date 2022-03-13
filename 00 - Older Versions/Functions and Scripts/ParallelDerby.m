function [Brho,Bz] = ParallelDerby(D,L,M,MagPos,Points,Ns,MM)

%% Building of the Reference System centered in the magnet centroid

 % vector from the center of the magnet to point of interest
 x   = Points - MagPos(1:3,:);   
 % z-component is the projection of x onto the z-axis
 z   = dot(x,MagPos(4:6,:));
 % radial component is the x-component if we consider only a plane
 rho = sqrt(vecnorm(x,2,1).^2-z.^2);

%% Computation of auxiliary variables
uni     = ones(1,Ns*MM);
B0      = (4*pi*1e-7*M/pi);  % simple Constant
R       = D/2;       % magnet radius

zP      = z + L/2;                  zM     = z - L/2;
alphaP  = R./sqrt(zP.^2+(rho+R).^2);   alphaM = R./sqrt(zM.^2+(rho+R).^2);
betaP   = zP./sqrt(zP.^2+(rho+R).^2);  betaM  = zM./sqrt(zM.^2+(rho+R).^2);
kP      = sqrt((zP.^2+(rho-R).^2)./(zP.^2+(rho+R).^2));   
kM      = sqrt((zM.^2+(rho-R).^2)./(zM.^2+(rho+R).^2));
gamma   = (R-rho)./(R+rho);

%% Computation of the field coordinates

Brho = B0*(alphaP.*ParallelBulirsch(kP,uni,uni,-uni,1e-7) - ...
                    alphaM.*ParallelBulirsch(kM,uni,uni,-uni,1e-7));
               
Bz   = B0*R./(R+rho).*(betaP.*ParallelBulirsch(kP,gamma.*gamma,uni,gamma,1e-7) - ...
                    betaM.*ParallelBulirsch(kM,gamma.*gamma,uni,gamma,1e-7));
