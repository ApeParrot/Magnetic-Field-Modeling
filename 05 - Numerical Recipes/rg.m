function  result = rg( x, y, z )
%RG Evaluates the Carlson's completely symmetric elliptic integral
%   of the 2nd kind [1].
%
%
%                       inf    x       y      z
%                       | | (----- + ----- + -----) t dt
%                   1   |    t + x   t + y   t + z              
%       rg(x,y,z) = -   |  ------------------------------------
%                   4   |  sqrt((t + x)*(t + y)*(t + z)) 
%                     | | 
%                      0
%
%   Result:
%       rg(x,y,z) -- Real scalar or NaN if either argument is invalid or
%           convergence failed.
%
%   Arguments:
%       x,y,z -- real scalars >= 0
%
%   Functions called:
%       rd, rf
%
%   Matlab function called:
%       abs, isinf, isnan, pi, sqrt
%
%   References:
%   [1] B.C.Carlson,"Numerical computation of real or complex elliptic 
%       integrals", Numerical Algorithms 10, 1995, pp 13-26.
%   [2] B.C.Carlson, "Elliptic Integrals" In: F.W.J.Olver et al., NIST
%       Handbook of Mathematical Functions, Cambridge, 2010.
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

    % Special cases

    if isinf(x) || isinf(y) || isinf(z)
        result = inf; %?????
        return
    end

    % sort x >= z >= y
    if x < y
        f = x; x = y; y = f;
    end
    if x < z
        f = x; x = z; z = f;
    end
    if y > z
        f = y; y = z; z = f;
    end
    
    % RG(x,x,x) [2] 19.20.4 (1)
    if x == y
        result = sqrt(x);           
        return
    end    
    
    % RG(x,0,0)[2] 19.20.4 (4)
    if z == 0
        result = 0.5*sqrt(x);       
        return
    end
    
    % RG(x,0,x)[2] 19.20.4 (3)
    if y == 0 && x == z
        result = pi/4*sqrt(x);
        return
    end
    
    % General case ([1] Eq 1.7) 
    
    s = sqrt((x/z)*y);
    f = z*rf(x,y,z);
    if z == x || z == y
        d = 0;
    else
        d = rd( x, y, z)/3;
        d = (x - z)*d;
        d = (z - y)*d;
    end
    result = 0.5*(f + d + s);

end


