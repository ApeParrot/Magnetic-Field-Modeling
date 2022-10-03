clc
clear
close all
%% Prepare MATLAB Workspace

wannaPrint = false;
printEPS   = true;

% store current path location
currentPath = pwd;
% move to the father directory
cd ..
% add folders to path
addpath(genpath("01 - Permanent Magnet Cylinders and Rings"))
addpath(genpath("05 - Numerical Recipes"))
% move back to the test directory
cd(currentPath)

addpath(genpath("field lines library"))

mu0 = 4*pi*1e-7;    % (T m / A) vacuum permittivity 
Br = 4*pi*1e-1;     % (T) Remanence
M = Br/mu0;         % (A/m) Magnetization N42
R = 0.01;           % (m) magnet radius
% L = R/2;           % (m) magnet semilength
% L = R;
L = 2*R;           % (m) magnet semilength

%% Skins

% Mvec = [1/2 0 sqrt(3)/2]*M;
Mvec = [sqrt(3)/2 0 1/2]*M;
% Mvec = [1/sqrt(2) 0 1/sqrt(2)]*M;
% plotFieldSkin2(R,L,Mvec)
plotFieldSkin3(R,L,Mvec,3)
% plotGradientSkin3(R,L,Mvec,1)
% fhandle = gcf;
axhandle = gca;
hold(axhandle,'on')
magV = [0 0 0; sqrt(3)/2 0 1/2]/400;
% magV = [0 0 0; 1/2 0 sqrt(3)/2]/200;
% magV = [0 0 0; 1/sqrt(2) 0 1/sqrt(2)]/200;
plot3(magV(:,1),magV(:,2),magV(:,3))
hold(axhandle,'off')

colorbar

figHandle = gcf;
figHandle.Children(1).Ticks = -0.6:0.2:0.2;

% 
if wannaPrint
    figHandle = gcf; %#ok<UNRCH>
%     set(figHandle,'renderer','Painters')
    print(figHandle,'MagnetSkin_L2_r1200_Hz_pi3_2.png','-dpng','-r1200');
end

%% Field Sections

% Mvec = [1 0 0]*M;
% plotFieldSection(R,L,Mvec)
% 
% Mvec = [0 0 1]*M;
% plotFieldSection(R,L,Mvec)

Mvec = [1/sqrt(2) 0 1/sqrt(2)]*M;
plotFieldSection(R,L,Mvec) % plot in plane xz

if wannaPrint
    figHandle = gcf; %#ok<UNRCH>
    if printEPS
        set(figHandle,'renderer','Painters')
        print -depsc -tiff -r300 -painters FieldSectionXZ_L1.eps
    else
        print(figHandle,'FieldSectionXZ_L1_r1200.png','-dpng','-r1200');
    end
end


plotFieldSection2(R,L,Mvec) % plot in plane yz

if wannaPrint
    figHandle = gcf; %#ok<UNRCH>
    if printEPS
        set(figHandle,'renderer','Painters')
        print -depsc -tiff -r300 -painters FieldSectionYZ_L1.eps
    else
        print(figHandle,'FieldSectionYZ_L1_r1200.png','-dpng','-r1200');
    end
end

