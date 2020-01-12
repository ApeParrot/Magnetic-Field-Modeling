%% Function drawCylindricalMagnet
 % -----------------------------------------------------------------------
 % This function draws a cylindrical magnet of length/height: L and
 % diameter D. The drawn magnet is translated according to the first three
 % coordinates of magnetPose (cartesian coordinates) and oriented according
 % to the last three coordinates of magnetPose (magnetic moment vector).
 %
 % Inputs: 
 %       1) L : length/height of the magnet;                     [number]
 %       2) D : diameter of the magnet;                          [number]
 %       3) magnetPose : is a 1*6 (or 6*1) array containing the three
 %                       cartesian coordinates of the desired center of the 
 %                       magnet and the three coordinates of the moment
 %                       vector used to retrieve the orientation of the
 %                       magnet.                                 [6x1]
 %
 % Notes: orientation of the magnet is computed from the moment vector
 % through the Rodrigues' rotation formula.
 %
 % ---------------------------------------------------------------------
 % July 20th, 2019                               Author: Federico Masiero
 % ---------------------------------------------------------------------
 %
 %                                          Last check: October 6th, 2019
 
function [] = drawCylindricalMagnet(L,D,magnetPose,varargin)

set(gcf,'renderer','opengl')

% default texture value
texture = 'normal';
% default color value for normal texture
color = [0.35 0.35 0.35];
% default color values for diametric and axial textures
colors = [1 0 0; 0 0 1];

while ~isempty(varargin)
    switch lower(varargin{1})
        case 'texture'
            if strcmp(varargin{2},'axial') || strcmp(varargin{2},'diametric') || strcmp(varargin{2},'normal')
                texture = varargin{2};
            else
                error('Wrong value for the Texture has been specified. You can specify only the values "normal", "axial" and "diametric"')
            end
        case 'color'
            if size(varargin{2},1) == 1 && strcmp(texture,'normal')
                color = varargin{2};
            elseif size(varargin{2},1) == 2 && (strcmp(texture,'axial') || strcmp(texture,'diametric'))
                colors = varargin{2};
            else
                error('Color specification is not compatible with texture selected.')
            end
        otherwise
            error(['Unexpected option: ' varargin{1}])
    end
    varargin(1:2) = [];
end

if strcmp(texture,'axial')
    
    % Cylinder dimensions
    h  = L;     % height
    ra = D/2;   % radius
    
    % Position where the magnet should be translated
    xp = magnetPose(1);
    yp = magnetPose(2);
    zp = magnetPose(3);
    % Magnet Orientation is given by its moment vector
    mx = magnetPose(4);
    my = magnetPose(5);
    mz = magnetPose(6);
    
    m  = [mx; my; mz];  % moment vector
    e3 = [ 0;  0;  1];  % z-axis unit vector
    
    [x1,y1,z1] = cylinder([0,ra,ra,0],300);
    z1 = z1*h/2;
    z1([1,2],:) = 0;
    z1([3,4],:) = h/2;
    z1 = z1-h/2;
    
    [x2,y2,z2] = cylinder([0,ra,ra,0],300);
    z2 = z2*h/2;
    z2([1,2],:) = 0;
    z2([3,4],:) = h/2;

    x = [x1 x2];
    y = [y1 y2]; 
    z = [z1 z2];
    
    xtemp = reshape(x,4*2*301,1);
    ytemp = reshape(y,4*2*301,1);
    ztemp = reshape(z,4*2*301,1);
    
    Points = [xtemp ytemp ztemp];
    
    if (abs(e3'*m) ~= 1)
        
        v = cross(e3,m);
        s = norm(v);      % sine of the angle
        c = e3'*m;        % cosine of the angle
        
        % skew symmetric tensor of v
        V = [  0    -v(3)   v(2) ; ...
              v(3)    0    -v(1) ; ...
            - v(2)   v(1)    0   ];
        
        % Rodrigues Formula to build the rotation
        % -> since this expression is not defined for |c| = 1, for these two
        %    cases we simply traslate the magnet (not distinguishable rotation)
        R = eye(3) + V + V*V*(1-c)/s^2;
        
        for u = 1:size(Points,1)
            temp        = R*(Points(u,:)');
            Points(u,:) = temp';
        end
        
        x = reshape(Points(:,1),4,301*2) + xp;
        y = reshape(Points(:,2),4,301*2) + yp;
        z = reshape(Points(:,3),4,301*2) + zp;
        
    else
        x = x + xp;
        y = y + yp;
        z = z + zp;
    end
    
    CC1 = surf(x(:,1:round(end/2)),y(:,1:round(end/2)),z(:,1:round(end/2)));
    hold on
    CC2 = surf(x(:,round(end/2)+1:end),y(:,round(end/2)+1:end),z(:,round(end/2)+1:end));
%     shading flat
    if e3'*m == 1
        set(CC1,'facecolor',colors(2,:),'edgecolor',colors(2,:));
        set(CC2,'facecolor',colors(1,:),'edgecolor',colors(1,:));
    else            % flip the colors if the magnets is flipped
        set(CC1,'facecolor',colors(1,:),'edgecolor',colors(1,:));
        set(CC2,'facecolor',colors(2,:),'edgecolor',colors(2,:));
    end
    light
    
else
    % Cylinder dimensions
    h  = L;     % height
    ra = D/2;   % radius
    
    % Position where the magnet should be translated
    xp = magnetPose(1);
    yp = magnetPose(2);
    zp = magnetPose(3);
    % Magnet Orientation is given by its moment vector
    mx = magnetPose(4);
    my = magnetPose(5);
    mz = magnetPose(6);
    
    m  = [mx; my; mz];  % moment vector
    e3 = [ 0;  0;  1];  % z-axis unit vector
    
    [x,y,z] = cylinder([0,ra,ra,0],300);
    z = z*h;
    z([1,2],:) = 0;
    z([3,4],:) = h;
    z = z-h/2;
    
    xtemp = reshape(x,4*301,1);
    ytemp = reshape(y,4*301,1);
    ztemp = reshape(z,4*301,1);
    
    Points = [xtemp ytemp ztemp];
    
    if (abs(e3'*m) ~= 1)
        
        v = cross(e3,m);
        s = norm(v);      % sine of the angle
        c = e3'*m;        % cosine of the angle
        
        % skew symmetric tensor of v
        V = [  0    -v(3)   v(2) ; ...
              v(3)    0    -v(1) ; ...
             -v(2)   v(1)    0   ];
        
        % Rodrigues Formula to build the rotation
        % -> since this expression is not defined for |c| = 1, for these two
        %    cases we simply traslate the magnet (not distinguishable rotation)
        R = eye(3) + V + V*V*(1-c)/s^2;
        
        for u = 1:size(Points,1)
            temp        = R*(Points(u,:)');
            Points(u,:) = temp';
        end
        
        x = reshape(Points(:,1),4,301) + xp;
        y = reshape(Points(:,2),4,301) + yp;
        z = reshape(Points(:,3),4,301) + zp;
        
    else
        x = x + xp;
        y = y + yp;
        z = z + zp;
    end
    
    if strcmp(texture,'normal')    % NORMAL TEXTURE
        CC = surf(x,y,z);
%         shading flat
        set(CC,'facecolor',color,'edgecolor',color);
        light          
    else                           % DIAMETRIC TEXTURE
        CC1 = surf(x(:,1:round(end/2)),y(:,1:round(end/2)),z(:,1:round(end/2)));
        hold on
        CC2 = surf(x(:,round(end/2):end),y(:,round(end/2):end),z(:,round(end/2):end));
%         shading flat
        set(CC1,'facecolor',colors(1,:),'edgecolor',colors(1,:));
        set(CC2,'facecolor',colors(2,:),'edgecolor',colors(2,:));
        light
    end
    
end

%% References
% Rodriguez's formula:
% from: https://math.stackexchange.com/questions/180418/calculate-rotation-matrix-to-align-vector-a-to-vector-b-in-3d