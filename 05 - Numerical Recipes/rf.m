function result = rf( x, y, z)
%RF evaluates the Carlson's incomplete or complete elliptic
%   integral of the 1st kind. 
%
%                       inf
%                       | |  
%                   1   |            dt
%       rf(x,y,z) = -   |  -----------------------
%                   2   |  sqrt((t+x)*(t+y)*(t+z)) 
%                     | | 
%                      0
%
%   Result:
%       rf(x,y,z) -- Real scalar or NaN if either argument is invalid or
%           convergence failed.
%
%   Arguments:
%       x,y,z  ---  real scalars >0, at most one can be zero
%
%   Functions called:
%       rc
%
%   Matlab functions called:
%       abs, isinf, isnan, sqrt
%
%   References:
%   [1] B.C.Carlson,"Numerical computation of real or complex elliptic 
%       integrals", Numerical Algorithms 10, 1995, pp 13-26.
%   [2] B.C.Carlson, "Elliptic Integrals" In: F.W.J.Olver et al., NIST 
%       Handbook of Mathematical Functions, Cambridge, 2010.
%   [3] W.H.Press et al., "Numerical Recipes in Fortran 90", 2nd ed., 
%       Cambridge, 1996
% 

    % Check input
    
    if isnan(x) || isnan(y) || isnan(z)
        result = NaN;
        return
    end
    
    if x < 0 || y < 0 || z < 0       
        result = NaN;
        return
    end
       
    if x + y == 0 || y + z == 0 || z + x == 0
        result = NaN;
        return
    end
    
    % Special cases
    
    if isinf(x) || isinf(y) || isinf(z)
        result = 0;
        return
    end
    
    if z == 0
        if x > 0
            % swap x and z
            t = x; x = z; z = t;
        end
    end
    if y == 0
        if x > 0
            % swap x and y
            t = x; x = y; y = t;
        end
    end
    
    if x == 0 && y == 0
        result = inf;                   % RF(0,0,z) [2] 19.20.1 (5)
        return
    end

    if x == y && y == z       
        result = 1/sqrt(x);             % RF(x,x,x) [2] 19.20.1 (1)
        return
    end
       
    if y == z
        if x == 0            
            result = pi/(2*sqrt(y));    % RF(0,y,y) [2] 19.20.1 (4)
        else          
            result = rc(x,y);           % RF(x,y,y) [2] 19.20.4
        end
        return
    end
   
    % General case (based on rf_s from [3])

    ERRTOL = 0.001;  % by tests

    while true
        rx = sqrt(x);
        ry = sqrt(y);
        rz = sqrt(z);
        lm  = rx*(ry + rz) + ry*rz;
        x  = 0.25*(lm + x);
        y  = 0.25*(lm + y);
        z  = 0.25*(lm + z);
        av  = (x + y + z)/3;
        if isinf(av)
            result = NaN;
            return
        end
        dx = (av - x)/av;
        dy = (av - y)/av;
        dz = (av - z)/av;
        if abs(dx) < ERRTOL && abs(dy) <ERRTOL && abs(dz) < ERRTOL
            break
        end
    end
    e2 = dx*dy - dz*dz;
    e3 = dx*dy*dz;
    
    C1 = 1/24;
    C2 = 1/10;
    C3 = 3/44;
    C4 = 1/14;
    s  = e2*(C1*e2 - C2 - C3*e3) + C4*e3;
    
    result = (1 + s)/sqrt(av);
    
end



