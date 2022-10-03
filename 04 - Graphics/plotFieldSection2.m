function [] = plotFieldSection2(R,L,Mvec)

mu0 = 4*pi*1e-7;
AXES_RANGES = [0 1];

% Points per coordinate in the grid
Npts = 600;
% Tolerance to discard points close the edges of the magnet
delta = 5e-4*R;    % (m)
% Select the max between R and L to generate a squared grid
D = max(R,L);

% Generating 2D grid in plane xz
[yPl,zPl] = meshgrid(linspace(-2*D,2*D,Npts),              ...
                     linspace(-2*D,2*D,Npts));

yPl = yPl(:);
zPl = zPl(:);
xPl = zeros(size(yPl));

% Nx3 array of observation points
points = [xPl yPl zPl];                      % in plane xz

% Compute the magnetic field H for the lateral, top and bottom surfaces
% using the intrinsic coordinate representation
H = computeField(R,L,Mvec,points);

inside = ( abs(yPl) < R-delta ) & ( abs(zPl) < L-delta );
% outside = ~inside;

M = norm(Mvec);
lambda = acos(Mvec(3)/M);

M_x = zeros(Npts^2,1); M_x(inside) = M*sin(lambda); 
M_y = zeros(Npts^2,1);
M_z = zeros(Npts^2,1); M_z(inside) = M*cos(lambda);

M_x = reshape(M_x,Npts,Npts);
M_y = reshape(M_y,Npts,Npts);
M_z = reshape(M_z,Npts,Npts);

xx = reshape(xPl,Npts,Npts);
yy = reshape(yPl,Npts,Npts);
zz = reshape(zPl,Npts,Npts);
H_x = reshape(H(:,1),Npts,Npts);
H_y = reshape(H(:,2),Npts,Npts);
H_z = reshape(H(:,3),Npts,Npts);
Hnorm = sqrt(H_x.^2 + H_y.^2+ H_z.^2)/M;

B_x = mu0*(reshape(H(:,1),Npts,Npts)+M_x);
B_y = mu0*(reshape(H(:,2),Npts,Npts)+M_y);
B_z = mu0*(reshape(H(:,3),Npts,Npts)+M_z);
Bnorm = sqrt(B_x.^2 + B_y.^2 + B_z.^2)/(M*mu0);

figure
subplot(121)
title("H-field",'interpreter','latex','fontsize',12)
hold on
contourf(yy,zz,Hnorm,60,'edgecolor','none')
l = streamslice(yy,zz,[],H_y,H_z,[],[],[],6,.5);
set(l,'LineWidth',1.2)
set(l,'Color','w')
rectangle('Position',[-R -L 2*R 2*L],'LineWidth',2)
hold off
axis equal
axis off
colormap("jet")
caxis(AXES_RANGES)

subplot(122)
title("B-field",'interpreter','latex','fontsize',12)
hold on
% surf(xx,zz,Bnorm,'edgecolor','none')
% view(0,-90)
contourf(yy,zz,Bnorm,60,'edgecolor','none')
l = streamslice(yy,zz,[],B_y,B_z,[],[],[],6,.5);
set(l,'LineWidth',1.2)
set(l,'Color','w')
rectangle('Position',[-R -L 2*R 2*L],'LineWidth',2)
hold off
axis equal
axis off
colormap("jet")
caxis(AXES_RANGES)