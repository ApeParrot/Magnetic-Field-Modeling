%% Ring magnetic field visualization
 % This script is a DEMO for the visualization of the magnetic flux density 
 % field lines of an axially magnetized ring. 

clc
clear all %#ok<CLALL>
close all
%%

MagPos = [0 0 0 0 0 1];

M = 1.2706/(4*pi*1e-7);              % Magnetization   [A/m]    
L = 0.006;
Rin  = 0.002;
Rout = 0.006;

spaceRegion = -0.1:0.001:0.1;
x = spaceRegion; z = x;
Npoints = length(x);
k = 1;

Brho = zeros(Npoints,Npoints); Baxial = Brho; B = Brho;

for i = 1:Npoints
    for j = 1:Npoints
        
        Point = [x(j) 0 z(i)];
        
        [Bx, By, Bz] = WrapRingBfield3(Rin,Rout,L,M,MagPos',Point');
        
        Brho(i,j)   = Bx;
        Baxial(i,j) = Bz;
        B(i,j)      = sqrt(Bx^2+Bz^2);
        
    end
end

%% planar field lines

D = Rout*2;

figure(1)
subplot(121)
plot_field = streamslice(x,z,Brho,Baxial,'method','cubic');
set(plot_field,'Color','black','LineWidth',1.2);
hold on
rectangle('Position',[0-D/2,0-L/2,D,L],'FaceColor',[0.2 0.2 0.2],...
    'EdgeColor',[0 0 0],'LineWidth',1)
hold on
rectangle('Position',[0-D/2,0-L/2,D,L/2],'FaceColor',[0 0 1])
hold on
rectangle('Position',[0-D/2,0,D,L/2],'FaceColor',[1 0 0])
subplot(122)
plot_field = streamslice(x,z,Brho,Baxial,'method','cubic');
set(plot_field,'Color','black','LineWidth',1.2);
hold on
rectangle('Position',[0-D/2,0-L/2,D,L/2],'FaceColor',[0 0 1])
hold on
rectangle('Position',[0-D/2,0,D,L/2],'FaceColor',[1 0 0])
axis([-0.04 0.04 -0.04 0.04])

%% Contour lines (logscale)

[xx,zz] = meshgrid(x);

step = 15;
figure(2) 
contourf(xx,zz,log10(B),1000,'EdgeColor','none')
colormap(jet)
colorbar
hold on 
h = streamline(xx,zz,Brho,Baxial,...
    xx(1:step:end,1:step:end),zz(1:step:end,1:step:end));
rectangle('Position',[0-D/2,0-L/2,D,L/2],'FaceColor',[0 0 1])
rectangle('Position',[0-D/2,0,D,L/2],'FaceColor',[1 0 0])
set(h,'Color','red');
% axis([-0.05 0.05 -0.05 0.05])
title('\textbf{Ring Magnet Model Field Lines}','interpreter','latex',...
    'fontsize',14)
xlabel('x [m]','interpreter','latex')
ylabel('z [m]','interpreter','latex')