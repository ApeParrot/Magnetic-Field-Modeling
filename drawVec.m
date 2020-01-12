function [] = drawVec(O,u,varargin)

%% Wrong inputs

if nargin < 2
    aac = matlab.lang.correction.AppendArgumentsCorrection('"O,v"');
    error(aac, 'MATLAB:notEnoughInputs', 'Not enough input arguments.')    %#ok<CTPCT>
end

%% Try to handle pathological inputs

switch size(O,1)
    case 1
        
    case 3
        if size(O,2) == 1
            O = O';
        else
            error('The last input is not a vector. Z must have three entries.')
        end
    otherwise
        error('The second input is not a vector. X must have three entries.')   
end

switch size(u,1)
    case 1
        
    case 3
        if size(u,2) == 1
            u = u';
        else
            error('The last input is not a vector. Z must have three entries.')
        end
    otherwise
        error('The second input is not a vector. X must have three entries.')   
end

%% Optional customizations

h = 0.2*norm(u);       % default height of the cone
w = 0.13*norm(u);      % default width of the cone

while ~isempty(varargin)
    switch lower(varargin{1})
        case 'arrowheadlength'
            if (size(varargin{2},1) == 1 && varargin{2} > 0 && varargin{2} < 0.5)
                h = varargin{2};
            else
                error('Arrow head length value is not compatible with the available range.')
            end
        case 'arrowheadwidth'
            if (size(varargin{2},1) == 1 && varargin{2} > 0 && varargin{2} < 0.5)
                w = varargin{2};
            else
                error('Arrow head width value is not compatible with the available range.')
            end
        otherwise
            error(['Unexpected option: ' varargin{1}])
    end
    varargin(1:2) = [];
end


%% Main function

    % vector to plot
vector = [O; O+u];

    % generation of the cone mesh
r = -linspace(0,h); 
th = linspace(0,2*pi);
[R,T] = meshgrid(r,th);
Xc = R.*cos(T)./(2*h).*w; % ./3 is for width scaling
Yc = R.*sin(T)./(2*h).*w;
Zc = R + h/2;

e3 = [0;0;1];

if ( abs(u*e3) ~= norm(u) )
    
    v = cross(e3,u);
    s = norm(v);     % sine of the angle
    c = u*e3;        % cosine of the angle
    
    % skew symmetric tensor of v
    V = [  0    -v(3)   v(2) ; ...
        v(3)    0    -v(1) ; ...
        - v(2)   v(1)    0   ];
    
    % Rodrigues Formula to build the rotation
    % -> since this expression is not defined for |c| = 1, for these two
    %    cases we simply traslate the magnet (not distinguishable rotation)
    Rot = eye(3) + V + V*V*(1-c)/s^2;
    
else
    
    if ( dot(u,e3) == norm(u) )
        Rot = eye(3);
    else
        Rot = [ 1      0          0   ;
                0   cosd(180) -sind(180);
                0   sind(180)  cosd(180) ];
    end
    
end

for i = 1:size(Xc,1)
    
    for j = 1:size(Xc,2)
        
        Xc1(i,j) = O(1)+u(1)+(Rot*([Xc(i,j); Yc(i,j); Zc(i,j)]))'*[1;0;0];
        Yc1(i,j) = O(2)+u(2)+(Rot*([Xc(i,j); Yc(i,j); Zc(i,j)]))'*[0;1;0];
        Zc1(i,j) = O(3)+u(3)+(Rot*([Xc(i,j); Yc(i,j); Zc(i,j)]))'*[0;0;1];
        
    end
    
end

    % plot the resulting axis, with their "arrows" and the origin
plot3(vector(:,1),vector(:,2),vector(:,3),'color','k','linewidth',1)
hold on
surf(Xc1,Yc1,Zc1,'FaceColor','k','EdgeColor','k')
