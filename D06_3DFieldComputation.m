%% Demo field computation comparison
 % This script shows the advantage of parallel computation of the field in
 % many points in space instead of the simple calculation of each point
 % separately.

clc
close all
clear all %#ok<CLALL>

% Poses of the magnets: the first three coordinates (per line) are the
% positions, while the last three coordinates are the dipole magnetic
% moment unit vectors, e.g. the orientation of each magnet (in this case 
% they are pointing downward, perpedicular to the sensor plane)
MagPos = [0  0.01 0.015 0 0 -1;
          0 -0.01 0.015 0 0 -1;
          0  0.03 0.015 0 0 -1;
          0 -0.03 0.015 0 0 -1]';      
      
MM = size(MagPos,2); 
D = 0.004*ones(MM,1); % Diameter of the magnets
L = 0.002*ones(MM,1); % Length of the magnets
M = 1.2706/(4*pi*1e-7)*ones(MM,1); % Magnetization of the magnets [A/m]

% Build a workspace of point of interest in planar arrangement below the
% plane of the magnets with 8 sensors along x and 16 sensors along y.
% Sensors lies in a equally spaced grid with step 0.009 m (9 mm).  
[SensorPosMatrix,WorkspaceDim] = buildWorkspace([8 16],0.009,0);

disp('Computation of the magnetic field in 128 points in space with a for loop with GenerateReadings.m :')
tic
Readings = GenerateReadings(MagPos',SensorPosMatrix,...
                                      M,D,L);
toc

disp('Contemporary computation of the magnetic field in 128 points with ParallelGenerateReadings.m :')
tic
Readings2 = ParallelGenerateReadings(D(1),L(1),M(1),MagPos,SensorPosMatrix');
toc

figure
scatter3(SensorPosMatrix(:,1),SensorPosMatrix(:,2),SensorPosMatrix(:,3))
for i = 1:MM
    hold on
    drawCylindricalMagnet(L(i),D(i),MagPos(:,i),'texture','axial')
    hold on
    drawVec(MagPos(1:3,i),MagPos(4:6,i)*0.005)
end
hold on
showFrame([0 0 0],[1 0 0]/100,[0 1 0]/100,[0 0 1]/100,...
                'arrowheadlength',0.35,...
                'arrowheadwidth',0.2)
hold on
quiver3(SensorPosMatrix(:,1),SensorPosMatrix(:,2),SensorPosMatrix(:,3),...
    Readings(:,1)/max(abs(Readings(:,1))),...
    Readings(:,2)/max(abs(Readings(:,2))),...
    Readings(:,3)/max(abs(Readings(:,3))))
hold off
axis([-80 80 -80 80 -80 80]/1000)
setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera')
grid off
axis off