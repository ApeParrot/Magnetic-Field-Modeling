%% Function buildWorkspace
 %
 % This function returns the cartesian coordinates of the array of sensors 
 % (SensorPosMatrix) and an array 6x1 containing the boundaries for each
 % dimension of the drawn workspace.
 %
 % Inputs: 
 %       1) gridS : is a vector of integer numbers used to select the
 %                  grid for sensor positioning.
 %                  In case of planar arrangement:
 %                  - gridS(1) : sensors along x-axis
 %                  - gridS(2) : sensors along y-axis
 %                  - gridS(3) : height of the workspace(optional)
 %                  In case of cylindrical arrangement:
 %                  - gridS(1) : number of sensors along the circumference
 %                  - gridS(2) : sensors along the axis of the cylinder
 %       2) ds    : is a number which expresses the distance in millimeter
 %                  between adjacent sensors
 %       3) type  : is a boolean value, and it is used to select the
 %                  geometry of workspace
 %                  - type = 0 : planar sensor array
 %                  - type = 1 : cylindrical sensor array
 %
 % author : Federico Masiero - 27/07/2019

function [SensorPosMatrix,WorkspaceDim] = buildWorkspace(gridS,ds,type)

Nsens  = gridS(1)*gridS(2);         % # sensors
SensorPosMatrix = zeros(Nsens,3);                                 

%% Planar arrangement
% ----------------------------------------------------------------------
if (type == 0)                                     
    
    % Specs for the plane arrangement
    xsn    = gridS(1);              % sensors # along x dimension
    ysn    = gridS(2);              % sensors # along y dimension
    
    % build the x-coordinate of the sensor grid
    if (mod(xsn,2) == 0)
        xsens = -(((xsn/2)-.5)*ds):ds:(((xsn/2)-.5)*ds);
    else
        xsens = -((xsn-1)*ds/2):ds:((xsn-1)*ds/2);
    end

% build the y-coordinate of the sensor grid
    if (mod(ysn,2) == 0)
        ysens = -(((ysn/2)-.5)*ds):ds:(((ysn/2)-.5)*ds);
    else
        ysens = -((ysn-1)*ds/2):ds:((ysn-1)*ds/2);
    end

    k = 1;
    for i = 1:length(xsens)
        for j = 1:length(ysens)
            SensorPosMatrix(k,:) = [xsens(i) ysens(j) 0];
            k = k+1;
        end
    end
    
    if ( length(gridS) == 2 )
        height = 75; % [mm]
    else
        height = gridS(3);
    end
    
    WorkspaceDim = [ min(SensorPosMatrix(:,1));
                     max(SensorPosMatrix(:,1));
                     min(SensorPosMatrix(:,2));
                     max(SensorPosMatrix(:,2));
                     min(SensorPosMatrix(:,3));
                     max(SensorPosMatrix(:,3))+height ];
    
end 

%% Cylindrical arrangement
% ----------------------------------------------------------------------
if (type == 1)

    csn   = gridS(1);               % Sensors along the circumference
    circL = csn*ds;                 % Length of the circumference [mm]
    r     = circL/(2*pi);           % upper arm radius, approx.   [mm]
    angle = 2*pi/csn;               % angle of the verteces       [rad]
    xc = 0; zc = r;                 % center of the circumference [mm]

% Build the y-coordinate of the sensor grid
    ysn   = gridS(2);
    if (mod(ysn,2) == 0)
        ysens = -(((ysn/2)-.5)*ds):ds:(((ysn/2)-.5)*ds);
    else
        ysens = -((ysn-1)*ds/2):ds:((ysn-1)*ds/2);
    end

    k = 1;
    for i = 1:length(ysens)
        for j = 1:csn
            if (mod(csn,2) == 0)
                csensx = xc+r*cos(angle/2+(j-1)*angle);
                csensz = zc+r*sin(angle/2+(j-1)*angle);
                SensorPosMatrix(k,:) = [csensx ysens(i) csensz];
            else
                csensx = xc+r*cos(angle*(j-1));
                csensz = zc+r*sin(angle*(j-1));
                SensorPosMatrix(k,:) = [csensx ysens(i) csensz];
            end
            k = k+1;
        end
    end
    
    WorkspaceDim = [ min(SensorPosMatrix(:,1));
                     max(SensorPosMatrix(:,1));
                     min(SensorPosMatrix(:,2));
                     max(SensorPosMatrix(:,2));
                     min(SensorPosMatrix(:,3));
                     max(SensorPosMatrix(:,3)) ];
    
end

