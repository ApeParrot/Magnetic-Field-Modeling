function [] = plotFieldSkin3(R,L,Mvec,component)

Npts = 300;         % points per coordinate in the grid
delta = 5e-4;       % (m)

% Generating 2D grid of lateral surface
[phiL,zL] = meshgrid(linspace(pi,2*pi,Npts),              ...
                     linspace(-L+delta,L-delta,Npts));
                   
% Generating 2D grid of top/bottom surface               
[phiC,rhoC] = meshgrid(linspace(pi,2*pi,Npts),            ...
                       linspace(0,R-delta,Npts));
                   
% Generating 2D grid of cylinder section
[xS,zS] = meshgrid(linspace(-R+delta,R-delta,Npts),      ...
                   linspace(-L+delta,L-delta,Npts));

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
% y coordinate of the section surface
yS = zeros(size(xS));

% arrange the vectors in a 1D array in column form
x = xL(:); y = yL(:); z = zL(:);
phiL = phiL(:);
phiC = phiC(:); rhoC = rhoC(:);
x2 = xC(:); y2 = yC(:);
x3 = xS(:); z3 = zS(:);

% Nx3 array of observation points
pointsL = [x y z];                              % Lateral surface
pointsT = [x2 y2 ones(Npts^2,1)*(L-delta)];     % Top surface
pointsB = [x2 y2 ones(Npts^2,1)*(-L+delta)];    % Bottom surface
pointsS = [x3 zeros(Npts^2,1) z3];              % Section surface

% Compute the magnetic field H for the lateral, top and bottom surfaces
% using the intrinsic coordinate representation
HL = computeField(R,L,Mvec,pointsL);
HT = computeField(R,L,Mvec,pointsT);
HB = computeField(R,L,Mvec,pointsB);
HS = computeField(R,L,Mvec,pointsS);

M = norm(Mvec);

H = [HL; HT; HB; HS];
if component >= 1 && component <= 3
    HL_norms = HL(:,component)/M; 
    HT_norms = HT(:,component)/M;
    HB_norms = HB(:,component)/M; 
    HS_norms = HS(:,component)/M;
else
    % adimensional field norms
    HL_norms = vecnorm(HL,2,2)/M; 
    HT_norms = vecnorm(HT,2,2)/M;
    HB_norms = vecnorm(HB,2,2)/M; 
    HS_norms = vecnorm(HS,2,2)/M;
end

Hnorms = [HL_norms; HT_norms; HB_norms; HS_norms];

N_LEVELS = 21;
% N_LEVELS = 20;
% LEVELS2JUMP = 5;
MaxH = max(Hnorms); 
AXES_RANGES = [-0.6 0.2];
% AXES_RANGES = [min(Hnorms) max(Hnorms)];
% AXES_RANGES = [-1 0.6];
% OPACITY = .7;
OPACITY = 1;
% CALPHA = .35;
CALPHA = 1;
V = linspace(AXES_RANGES(1),AXES_RANGES(2),N_LEVELS);

linesCartesian = {};

% To attach to the skin the contour of the magnetic field, we need to store
% the contour lines (assigned to the corresponding domain, i.e., lateral 
% surf, top, bottom, section).
% To do so, we first perform the contour for each patch, storing in c1 the 
% contour object. After that, we normalize the colorbar by imposing the
% AXES_RANGES (this is done to force all contour to follow the same axes 
% and levels). Then, we store the contour lines that can be retrieved in
% the ContourMatrix property of the c1 object.
% Since ContourMatrix are store in a special 2D format, such matrix needs
% to be parsed in order to reconstruct correctly the lines for each patch.
% When doing this, we trasform the patch coordinates to the corresponding
% cartesian ones (adding also the 3rd coordinate/dimension).


figure

% ---- LATERAL SURFACE
subplot(2,2,1)
[~,c1] = contourf( reshape(phiL,Npts,Npts),...
                   reshape(zL,Npts,Npts),...
                   reshape(HL_norms,Npts,Npts),V);
colormap(jet)               % colormap
caxis(AXES_RANGES)          % forcing ranges
M1 = c1.ContourMatrix;      % extracting contour matrix

% index to store ALL the contour lines
k = 1;

% parsing the contour matrix of the contour object 
for j = 1:size(M1,2)
    
    % when the number in ContourMatrix is an integer it means we found the
    % number of vertices/points after it at that contour level. Those
    % points are the ones needed to reconstruct the contour line.
    if mod(M1(2,j),1) == 0
        Nvertices = M1(2,j);
        temp = M1( :, (j+1):(j+Nvertices) );
        linesCartesian{k} = [(R-delta)*cos(temp(1,:));...
                             (R-delta)*sin(temp(1,:));...
                              temp(2,:)];
        k = k+1;
    end
        
end

% ---- TOP SURFACE
subplot(2,2,2)
[~,c1] = contourf( reshape(x2,Npts,Npts),...
                   reshape(y2,Npts,Npts),...
                   reshape(HT_norms,Npts,Npts),V);
colormap(jet)
caxis(AXES_RANGES)
M1 = c1.ContourMatrix;
for j = 1:size(M1,2)
    
    if mod(M1(2,j),1) == 0
        Nvertices = M1(2,j);
        temp = M1( :, (j+1):(j+Nvertices) );
        linesCartesian{k} = [temp(1,:);temp(2,:);...
                             ones(1,Nvertices)*(L-delta)];
        k = k+1;
    end
        
end

% ---- BOTTOM SURFACE
subplot(2,2,3)
[~,c1] = contourf( reshape(x2,Npts,Npts),...
                   reshape(y2,Npts,Npts),...
                   reshape(HB_norms,Npts,Npts),V);
colormap(jet)
caxis(AXES_RANGES)
M1 = c1.ContourMatrix;
for j = 1:size(M1,2)
    
    % number in ContourMatrix is integer -> number of verteces after it
    if mod(M1(2,j),1) == 0
        Nvertices = M1(2,j);
        temp = M1( :, (j+1):(j+Nvertices) );
        linesCartesian{k} = [temp(1,:);temp(2,:);...
                             ones(1,Nvertices)*(-L+delta)];
        k = k+1;
    end
        
end

% ---- SECTION SURFACE
subplot(2,2,4)
[~,c1] = contourf( reshape(x3,Npts,Npts),...
                   reshape(z3,Npts,Npts),...
                   reshape(HS_norms,Npts,Npts),V);
colormap(jet)
caxis(AXES_RANGES)
M1 = c1.ContourMatrix;
for j = 1:size(M1,2)
    
    % number in ContourMatrix is integer -> number of verteces after it
    if mod(M1(2,j),1) == 0
        Nvertices = M1(2,j);
        temp = M1( :, (j+1):(j+Nvertices) );
        linesCartesian{k} = [temp(1,:);...
                             zeros(1,Nvertices);...
                             temp(2,:);];
        k = k+1;
    end
        
end

 close all
 
% to set the 3D view
ANGLE1 = 130;
ANGLE2 = 30;

% aux variables for the arrows drawn with arrow3 library
arrowL = 0.015;      %(m)
magArrowL = 0.025;   %(m)

% settings for figure location (in screen) and size
aspectRatio = 1.5;
xScale = 0.5;
yScale = xScale*aspectRatio;
xPos = 0.5-xScale/2;
yPos = 0.5-yScale/2;
    
figure("Units","normalized","Position",[xPos yPos xScale yScale])

hold on
axis([-R R -R R -R R]*2)
surf(xL,yL,zL,reshape(HL_norms,Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)
surf(xC,yC,zCT,reshape(HT_norms,Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)
surf(xC,yC,zCB,reshape(HB_norms,Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)
surf(xS,yS,zS,reshape(HS_norms,Npts,Npts),'edgecolor','none',...
    'facecolor','interp','facealpha',OPACITY)

% plot unit vectors and magnetization
% arrow3([R 0 0],[R 0 0]+[arrowL 0 0],'/k',1.5,3)
% arrow3([0 0 L],[0 0 L]+[0 0 arrowL],'/k',1.5,3)
% arrow3([0 0 0],[magArrowL 0 magArrowL],'/k',1.5,3,.75)

% labels positions
% vecVertex(1,:) = [R 0 0]+[arrowL 0 0];
% vecVertex(2,:) = [0 0 L]+[0 0 arrowL];
vecVertex(3,:) = [magArrowL 0 magArrowL];

% draw contours in patches
for j = 1:size(linesCartesian,2)
    if ~isempty(linesCartesian{j})
        p = plot3(  linesCartesian{j}(1,:),...
                    linesCartesian{j}(2,:),...
                    linesCartesian{j}(3,:),'color',...
                    [0 0 0 CALPHA]);
%                     [1 1 1 CALPHA]);
    end
end


ptXCirc = 30;
ang = linspace(pi,2*pi,ptXCirc)';
magBoundaries = [-R+delta 0 -L+delta
                  R-delta 0 -L+delta
                  R-delta 0  L-delta
                 -R+delta 0  L-delta
                 -R+delta 0 -L+delta];
magBoundaries = [ magBoundaries
                  (R-delta)*cos(ang) (R-delta)*sin(ang) (-L+delta)*ones(size(ang))];
magBoundaries = [ magBoundaries 
                 R-delta 0  L-delta];
magBoundaries = [ magBoundaries 
                  (R-delta)*cos(flipud(ang)) (R-delta)*sin(flipud(ang)) (L-delta)*ones(size(ang))];              

% draw magnet section boundaries
plot3(magBoundaries(:,1),magBoundaries(:,2),magBoundaries(:,3),...
      'k','linewidth',1)

% magVecRef = [0 0 0; 0.01 0 0.01];  
% plot3(magVecRef(:,1),magVecRef(:,2),magVecRef(:,3))  
  
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

% set orientation of the figure
view(ANGLE1,ANGLE2)
