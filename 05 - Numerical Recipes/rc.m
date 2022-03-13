function result = rc( x, y )
%RC Evaluates Carlson's degenerate elliptic integral of the 
%   1st kind [1]
%
%                     inf
%                     | |  
%                 1   |        dt
%       rc(x,y) = -   |  -------------------
%                 2   |  (t + y)*sqrt(t + x) 
%                   | | 
%                    0
%
%   Result:
%       rc(x,y) -- Real scalar or NaN if either argument is invalid or
%           convergence failed. For y < 0 result is Cauchy principal value.
%
%   Arguments:
%       x     ---  real scalar >=0
%       y     ---  real scalar != 0 
%
%   Functions called:
%       NONE
%
%   Matlab functions called:
%       abs, isinf, isnan, pi, sqrt
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
    
    if isnan(x) || isnan(y) || x < 0 || y == 0
        result = NaN;
        return
    end
       
    % Special cases
    
    if isinf(x) || isinf(y)
        result = 0;
        return
    end
    
    % RC(x,0) [2] 19.6.15
    if  y == 0 
        result = inf;  
        return
    end

    % RC(0,y) [2] 19.6.15
    if x == 0 && y > 0    
        result = pi/(2*sqrt(y)); 
        return
    end
    
    % RC(x,x) [2] 19.6.15
    if x == y
        result = 1/sqrt(x); 
        return
    end
    
    % General case (based on rc_s from [3])
    
    if y > 0
        w = 1;
    else
        w = sqrt(x/(x - y));
        x = x - y;
        y = -y;      
    end
    
    ERRTOL = 3e-4; % by tests
    
    while true
        p = 2*sqrt(x*y) + y;       
        x = 0.25*(x + p);
        y = 0.25*(y + p);
        s = x + y + y;
        m = s/3;
        s = (y - x)/s;
        if isnan(s)
            result = NaN;
            return
        end
        if abs(s) < ERRTOL
            break
        end
    end
    C1 = 0.3;
    C2 = 1/7;
    C3 = 0.375;
    C4 = 9/22;
    s  = (C1 + s*(C2 + s*(C3 + s*C4)))*s*s;
    
    result = w*((1 + s)/sqrt(m));

end

