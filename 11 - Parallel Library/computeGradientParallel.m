function G = computeGradientParallel(R,L,Mstar,O,e_par,e_bot,points) 

% center and reference frame vectors of the cylinder recasted as 1D column
% vectors
O = O(:);
e_par = e_par(:);
e_bot = e_bot(:);

% residual magnetization
Mstar = Mstar(:);                   % make this as a column vector
M_p   = (Mstar'*e_par);
M_b   = (Mstar'*e_bot);
M_par = M_p*e_par;
M_bot = M_b*e_bot;

% Array of points of interest should be provided as an N x 3 matrix
if size(points,2) ~= 3
    points = points';
end

x = points(:,1);
y = points(:,2);
z = points(:,3);
[rho,~,z,L,~,~,~,c,s] = prepareVariablesParallel(x,y,z,O,...
                                                 e_par,e_bot,...
                                                 M_par,M_bot,...
                                                 L,R);

vars  = auxiliaryVarsParallel(rho,z,L);

% Gradient Field computation in coordinate free representation Eq.(22)
f2 = fun2Parallel(rho,z,L,vars);
f3 = fun3Parallel(rho,z,L,vars);
f4 = fun4Parallel(rho,z,L,vars);
f5 = fun5Parallel(rho,z,L,vars);

g  = 2*f3-f5;
g1 = c.^2.*g;
g2 = s.*c.*g;
g3 = s.^2.*g;
g4 = c.*f4;
g5 = s.*f4;
g6 = 8*f2+f4;

% If the gradient is computed in a unique point, we return it in matrix
% form, otherwise we return a matrix N x 5
if size(x,1) == 1
    if rho ~= 0
        % field gradient outside magnet axis (rho = 0)
        J_par = [ g1-f3     g2   g4
                     g2  g3-f3   g5
                     g4     g5   f5 ];
        
        J_bot = [ c*(6*f2-c^2*g6)  s*(2*f2-c^2*g6)  g1-f3
                  s*(2*f2-c^2*g6)  c*(2*f2-s^2*g6)     g2
                            g1-f3               g2     g4 ];
    else
        % field gradient in magnet axis
        gstar = pi/4*( (1+vars.zP^2)^(-3/2) - ...
                       (1+vars.zM^2)^(-3/2) );
        
        J_par = [-gstar      0      0
                      0 -gstar      0
                      0      0 2*gstar];
        
        J_bot = [     0      0 -gstar
                      0      0      0
                 -gstar      0      0];
    end

else

    % field gradient outside magnet axis (rho = 0)
    J_par = [g1-f3, g3-f3, g2, g4, g5];
    J_bot = [ c.*(6*f2-c.^2.*g6),...
              c.*(2*f2-s.^2.*g6),...
              s.*(2*f2-c.^2.*g6),...
                           g1-f3,...
                              g2 ];
    
    % numerical threshold
    th = eps;
    onAxis = rho <= th;
    % field gradient in magnet axis
    if sum(onAxis) ~= 0
        gstar = pi/4*( (1+vars.zP(onAxis).^2).^(-3/2) - ...
                       (1+vars.zM(onAxis).^2).^(-3/2) );
        
        J_par(onAxis,1) = -gstar;
        J_par(onAxis,2) = -gstar;
        
        J_bot(onAxis,4) = -gstar;
    end
    
end


G = (M_p*J_par + M_b*J_bot)/(pi*R);