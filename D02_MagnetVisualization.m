clc
clear all %#ok<CLALL>
close all
%%

position = [0 0 0];
         
orientation = 2*rand(1,3) - [1 1 1];
orientation = orientation/norm(orientation);

figure
x0     = 10;
y0     = 110;
width  = 1260;
height = 480;
set(gcf,'position',[x0,y0,width,height])
subplot(251)
drawRingMagnet(0.002,0.0007,0.002,[position 0 0 1],'texture','axial')
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
title('AXIAL, $\mathbf{m} = [\,0\quad 0\quad 1\,]$','interpreter','latex')
subplot(252)
drawRingMagnet(0.002,0.0007,0.002,[position 0 0 -1],'texture','axial')
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
title('AXIAL, $\mathbf{m} = [\,0\quad 0\; -1\,]$','interpreter','latex')
subplot(253)
drawRingMagnet(0.002,0.0007,0.002,[position 1 0 0],'texture','axial')
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
title('AXIAL, $\mathbf{m} = [\,1\quad 0\quad 0\,]$','interpreter','latex')
subplot(254)
drawRingMagnet(0.002,0.0007,0.002,[position 0 1 0],'texture','axial')
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
title('AXIAL, $\mathbf{m} = [\,0\quad 1\quad 0\,]$','interpreter','latex')
subplot(255)
drawRingMagnet(0.002,0.0007,0.002,[position 0 0 1],'texture','diametric')
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
title('DIAMETRIC, $\mathbf{m} = [\,0\quad 0\quad 1\,]$','interpreter','latex')
subplot(256)
drawRingMagnet(0.002,0.0007,0.002,[position 1 0 0],'texture','diametric')
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
title('DIAMETRIC, $\mathbf{m} = [\,1\quad 0\quad 0\,]$','interpreter','latex')
subplot(257)
drawRingMagnet(0.002,0.0007,0.002,[position 1/sqrt(2) 1/sqrt(2) 0])
title('NORMAL, $\mathbf{m} = [\,1/\sqrt{2}\quad 1/\sqrt{2}\quad 0\,]$','interpreter','latex')
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
subplot(258)
drawRingMagnet(0.002,0.0007,0.001,[position 0 0 1],'texture','axial')
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
title('Fun with \textbf{GEOMETRY}','interpreter','latex')
subplot(259)
drawRingMagnet(0.002,0.0007,0.002,[position 0 0 1],'texture','axial','color',[0 1 0; 1 0 1])
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
title('Fun with \textbf{COLORS}','interpreter','latex')
subplot(2,5,10)
drawRingMagnet(0.002,0.001,0.004,[position -1/sqrt(2) 0 1/sqrt(2)],'texture','diametric','color',[0 1 0; 1 0 1])
axis([-0.01 0.01 -0.01 0.01 -0.01 0.01])
title('\textbf{ALTOGETHER}','interpreter','latex')
