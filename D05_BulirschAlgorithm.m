%% DEMO PARALLEL BULIRSCH
 % This script provides a comparison of the parallel implementation of the 
 % Bulirsch Algorithm w.r.t. to the original algorithm.
 % The comparison is performed though the computation of two example of
 % generalized complete elliptic integrals, which are:
 % - C(kc,1,1,-1)
 % - C(kc,g^2),1,g)
 % which are also used in the efficient computation of the magnetic flux
 % density of axially magnetized cylinders and rings.
 
clc
clear all %#ok<CLALL>
close all
%%

kc    = linspace(0.01,0.99,100*6*2);
rho   = linspace(0.01,0.08,100*6*2);
gamma = (0.002-rho)./(0.002+rho);
Tol = 1e-7;
Cnp = zeros(size(kc));
Cnp2 = zeros(size(kc));
uni = ones(size(kc));

disp('ParallelBulirsch computation time of 1200 integrals C(kc,1,1,-1)')
tic
Cp = ParallelBulirsch(kc,uni,uni,-uni,Tol);
toc

disp('GeneralizedEllipke computation time of 1200 integrals C(kc,1,1,-1)')
tic
for i = 1:length(kc)
    Cnp(i) = GeneralizedEllipke(kc(i),1,1,-1,Tol);
end
toc

disp('ParallelBulirsch computation time of 1200 integrals C(kc,g^2,1,g)')
tic
Cp2 = ParallelBulirsch(kc,gamma.*gamma,uni,gamma,Tol);
toc

disp('GeneralizedEllipke computation time of 1200 integrals C(kc,g^2,1,g)')
tic
for i = 1:length(kc)
    Cnp2(i) = GeneralizedEllipke(kc(i),gamma(i)*gamma(i),1,gamma(i),Tol);
end
toc
