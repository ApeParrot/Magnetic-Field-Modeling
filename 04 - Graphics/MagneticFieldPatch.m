clc
clear
close all
%% Prepare MATLAB Workspace

% store current path location
currentPath = pwd;
% move to the father directory
cd ..
% add folders to path
addpath(genpath("01 - Permanent Magnet Cylinders and Rings"))
addpath(genpath("05 - Numerical Recipes"))
% move back to the test directory
cd(currentPath)

mu0 = 4*pi*1e-7;    % (T m / A) vacuum permittivity 
Br = 1.27;          % (T) Remanence
M = Br/mu0;         % (A/m) Magnetization N45
R = 0.02;           % (m) magnet radius
L = 0.01;           % (m) magnet semilength

%% Purely axial magnetization
Mvec = [1/sqrt(2); 0; 1/sqrt(2)]*M; 

Npts = 100;         % points per coordinate in the grid
delta = 1e-6;

% Generating 2D grid of lateral surface
[phiL,zL] = meshgrid(linspace(0,2*pi,Npts),      ...
                     linspace(-L+delta,L-delta,Npts));
                   
% Generating 2D grid of top/bottom surface               
[phiC,rhoC] = meshgrid(linspace(0,2*pi,Npts),      ...
                       linspace(0,R-delta,Npts));    

% x and y coordinates in the lateral surface of a cylinder                   
xL = (R-delta)*cos(phiL);
yL = (R-delta)*sin(phiL);
% x and y coordinates in a circle  
xC = rhoC.*cos(phiC);
yC = rhoC.*sin(phiC);
% z coordinate of the top surface
zCT = ones(size(xC))*(L-delta);
% z coordinate of the bottom surface
zCB = ones(size(xC))*(-L+delta);

% arrange the vectors in a 1D array in column form
x = xL(:);
y = yL(:);
z = zL(:);
phiL = phiL(:);
phiC = phiC(:);
rhoC = rhoC(:);
x2 = xC(:);
y2 = yC(:);

% Nx3 array of observation points
pointsL = [x y z];                              % Lateral surface
pointsT = [x2 y2 ones(Npts^2,1)*(L-delta)];     % Top surface
pointsB = [x2 y2 ones(Npts^2,1)*(-L+delta)];    % Bottom surface

% Compute the magnetic field H for the lateral, top and bottom surfaces
% using the intrinsic coordinate representation
HL = computeField(R,L,Mvec,pointsL);
HT = computeField(R,L,Mvec,pointsT);
HB = computeField(R,L,Mvec,pointsB);

%% Magnet "Skin" Plot for Axial Magnetization

H = [HL; HT; HB];
Hnorms = vecnorm(H(1:2,:),2,2);
Hmaxrho = max(Hnorms);
Hmaxz   = max(abs(H(:,3)));

N_LEVELS = 16;
LEVELS2JUMP = 5;
AXES_RANGES = [-1 1]*6e5;
OPACITY = .7;
CALPHA = .35;
V = linspace(AXES_RANGES(1),AXES_RANGES(2),N_LEVELS);
% V = V(1:LEVELS2JUMP:end);
% V(2) = [];
% V(end-2:end-1) = [];

lines = {};
linesCartesian = {};

figure

for i = 1:3
    
subplot(3,3,(i-1)*3+1)
[~,c1] = contourf( reshape(phiL,Npts,Npts),...
                   reshape(zL,Npts,Npts),...
                   reshape(HL(:,i),Npts,Npts),V);
colormap(jet)
caxis(AXES_RANGES)
M1 = c1.ContourMatrix;

k = 1;
for j = 1:size(M1,2)
    
    % number in ContourMatrix is integer -> number of verteces after it
    if mod(M1(2,j),1) == 0
        Nvertices = M1(2,j);
        temp = M1( :, (j+1):(j+Nvertices) );
        lines{i,k} = temp;
        linesCartesian{i,k} = [(R-delta)*cos(temp(1,:));...
                             (R-delta)*sin(temp(1,:));...
                             temp(2,:)];
        k = k+1;
    end
        
end
subplot(3,3,(i-1)*3+2)
[~,c1] = contourf( reshape(x2,Npts,Npts),...
                   reshape(y2,Npts,Npts),...
                   reshape(HT(:,i),Npts,Npts),V);
colormap(jet)
caxis(AXES_RANGES)
M1 = c1.ContourMatrix;
for j = 1:size(M1,2)
    
    % number in ContourMatrix is integer -> number of verteces after it
    if mod(M1(2,j),1) == 0
        Nvertices = M1(2,j);
        temp = M1( :, (j+1):(j+Nvertices) );
        lines{i,k} = temp;
        linesCartesian{i,k} = [temp(1,:);temp(2,:);...
                               ones(1,Nvertices)*(L-delta)];
        k = k+1;
    end
        
end
subplot(3,3,(i-1)*3+3)
[~,c1] = contourf( reshape(x2,Npts,Npts),...
                   reshape(y2,Npts,Npts),...
                   reshape(HB(:,i),Npts,Npts),V);
colormap(jet)
caxis(AXES_RANGES)
M1 = c1.ContourMatrix;
for j = 1:size(M1,2)
    
    % number in ContourMatrix is integer -> number of verteces after it
    if mod(M1(2,j),1) == 0
        Nvertices = M1(2,j);
        temp = M1( :, (j+1):(j+Nvertices) );
        lines{i,k} = temp;
        linesCartesian{i,k} = [temp(1,:);temp(2,:);...
                             ones(1,Nvertices)*(-L+delta)];
        k = k+1;
    end
        
end

end

% figure('renderer','painter')
figure
subplot(131)
hold on
axis([-R R -R R -R R]*2)
surf(xL,yL,zL,reshape(HL(:,1),Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)
surf(xC,yC,zCT,reshape(HT(:,1),Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)
surf(xC,yC,zCB,reshape(HB(:,1),Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)
% arrow3([0 0 0],[1 0 1]*sqrt(3)/100,'k',2,3,.75)
vecVertex(1,:) = [R 0 0]+[2 0 0]/100;
arrow3([R 0 0],[R 0 0]+[2 0 0]/100,'k')
arrow3([0 0 L],[0 0 L]+[0 0 2]/100,'k')
arrow3([0 0 0],[1 0 1]*sqrt(3)/100,'r')
text(vecVertex(1,1)+0.01,vecVertex(1,2),vecVertex(1,3)+0.01,...
    '$\hat{\mathbf{e}}_\bot$','interpreter','latex',...
    'fontsize',13)
% text(p(2,1),p(2,2),p(2,3),'\bfV')
% text(p(3,1),p(3,2),p(3,3),'\bfW')
for j = 1:length(linesCartesian)
    p = plot3(linesCartesian{1,j}(1,:),...
          linesCartesian{1,j}(2,:),...
          linesCartesian{1,j}(3,:),'color',...
          [1 1 1 CALPHA]);
end
hold off
colormap(jet)
% caxis([-Hmaxrho Hmaxrho])
caxis(AXES_RANGES)
axis equal
axis off
title("$\mathrm{H}_\mathrm{x}$","fontsize",14,"Interpreter","latex")
view(135,32)
colorbar('southoutside')

subplot(132)
hold on
surf(xL,yL,zL,reshape(HL(:,2),Npts,Npts),'edgecolor','none')
surf(xC,yC,zCT,reshape(HT(:,2),Npts,Npts),'edgecolor','none')
surf(xC,yC,zCB,reshape(HB(:,2),Npts,Npts),'edgecolor','none')
hold off
colormap(jet)
% caxis([-Hmaxrho Hmaxrho])
caxis(AXES_RANGES)
axis equal
axis off
title("$\mathrm{H}_\mathrm{y}$","fontsize",14,"Interpreter","latex")
view(30,25)
colorbar('southoutside')

subplot(133)
hold on
surf(xL,yL,zL,reshape(HL(:,3),Npts,Npts),'edgecolor','none')
surf(xC,yC,zCT,reshape(HT(:,3),Npts,Npts),'edgecolor','none')
surf(xC,yC,zCB,reshape(HB(:,3),Npts,Npts),'edgecolor','none')
hold off
colormap('jet')
% caxis([-Hmaxrho Hmaxrho])
caxis(AXES_RANGES)
axis equal
axis off
title("$\mathrm{H}_\mathrm{z}$","fontsize",14,"Interpreter","latex")
view(30,25)
colorbar('southoutside')

%%
 clc
 close all

addpath(genpath("export_fig-master")) 
 
% if true, set the renderer to painter (high quality image) and print the 
% figures in eps format 
wannaPrint = false; 
 
% to set the 3D view
ANGLE1 = 135;
ANGLE2 = 30;

% aux variables for the arrows drawn with arrow3 library
arrowL = 0.015;      %(m)
magArrowL = 0.025;   %(m)

% settings for figure location (in screen) and size
aspectRatio = 2;
xScale = 0.5;
yScale = xScale*aspectRatio;
xPos = 0.5-xScale/2;
yPos = 0.5-yScale/2;

for i = 1:3
    
switch i
    case 1
        component = "x";
    case 2
        component = "y";
    case 3
        component = "z";
end
    
figure("Units","normalized","Position",[xPos yPos xScale yScale])

hold on
axis([-R R -R R -R R]*2)
surf(xL,yL,zL,reshape(HL(:,i),Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)
surf(xC,yC,zCT,reshape(HT(:,i),Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)
surf(xC,yC,zCB,reshape(HB(:,i),Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)

% plot unit vectors and magnetization
arrow3([R 0 0],[R 0 0]+[arrowL 0 0],'/k',1.5,3)
arrow3([0 0 L],[0 0 L]+[0 0 arrowL],'/k',1.5,3)
arrow3([0 0 0],[magArrowL 0 magArrowL],'/r',1.5,3,.75)

% labels positions
vecVertex(1,:) = [R 0 0]+[arrowL 0 0];
vecVertex(2,:) = [0 0 L]+[0 0 arrowL];
vecVertex(3,:) = [magArrowL 0 magArrowL];

% print labels
text(vecVertex(1,1)+0.01,vecVertex(1,2),vecVertex(1,3)+0.01,...
    '$\hat{\mathbf{e}}_\bot$','interpreter','latex',...
    'fontsize',13)
text(vecVertex(2,1)+0.005,vecVertex(2,2),vecVertex(2,3)+0.01,...
    '$\hat{\mathbf{e}}_\parallel$','interpreter','latex',...
    'fontsize',13)
text(vecVertex(3,1)+0.01,vecVertex(3,2),vecVertex(3,3)+0.01,...
    '$\mathbf{M}^\star$','interpreter','latex',...
    'fontsize',13,'color','r')
labelField = "$\mathrm{H}_\mathrm{" + component + "}$";
text(0,0.035,0,...
    labelField,'interpreter','latex',...
    'fontsize',15)

% draw contours in patches
for j = 1:size(linesCartesian,2)
    if ~isempty(linesCartesian{i,j})
        p = plot3(linesCartesian{i,j}(1,:),...
            linesCartesian{i,j}(2,:),...
            linesCartesian{i,j}(3,:),'color',...
            [1 1 1 CALPHA]);
    end
end
hold off

% set the colormap texture
colormap(jet)
% caxis([-Hmaxrho Hmaxrho])

% change colormap range 
caxis(AXES_RANGES)

% squeeze axis figure to the actual ranges that are covered
axis equal

% remove axis from figure
axis off
% title("$\mathrm{H}_\mathrm{x}$","fontsize",14,"Interpreter","latex")

% set orientation of the figure
view(ANGLE1,ANGLE2)
colorbar('southoutside')

if wannaPrint
    figHandle = gcf; %#ok<UNRCH>
%     set(figHandle,"renderer","painter")
    
    switch i
        case 1
            export_fig magSkinPlotHx -pdf -eps
        case 2
            export_fig magSkinPlotHy -pdf -eps
        case 3
            export_fig magSkinPlotHz -pdf -eps
    end
    
end

end



% figure
% hold on
% axis([-R R -R R -R R]*2)
% surf(xL,yL,zL,reshape(HL(:,2),Npts,Npts),'edgecolor','none')
% surf(xC,yC,zCT,reshape(HT(:,2),Npts,Npts),'edgecolor','none')
% surf(xC,yC,zCB,reshape(HB(:,2),Npts,Npts),'edgecolor','none')
% hold off
% colormap(jet)
% % caxis([-Hmaxrho Hmaxrho])
% caxis(AXES_RANGES)
% axis equal
% % axis off
% % title("$\mathrm{H}_\mathrm{y}$","fontsize",14,"Interpreter","latex")
% view(ANGLE1,ANGLE2)
% % colorbar('southoutside')
% 
% figure
% hold on
% axis([-R R -R R -R R]*2)
% surf(xL,yL,zL,reshape(HL(:,3),Npts,Npts),'edgecolor','none')
% surf(xC,yC,zCT,reshape(HT(:,3),Npts,Npts),'edgecolor','none')
% surf(xC,yC,zCB,reshape(HB(:,3),Npts,Npts),'edgecolor','none')
% hold off
% colormap('jet')
% % caxis([-Hmaxrho Hmaxrho])
% caxis(AXES_RANGES)
% axis equal
% % axis off
% % title("$\mathrm{H}_\mathrm{z}$","fontsize",14,"Interpreter","latex")
% view(ANGLE1,ANGLE2)
% % colorbar('southoutside')