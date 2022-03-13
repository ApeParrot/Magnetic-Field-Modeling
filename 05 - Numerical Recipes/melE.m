function result = melE( x, m )
%MELE Evaluates the incomplete elliptic integrals of the 2nd kind
%
%                  x
%                 | |  
%                 |   sqrt(1 - m*t^2)
%       E(x,m) =  |  ---------------- dt
%                 |   sqrt(1 -   t^2) 
%               | | 
%                0
%
%   Result:
%       E(x,m) -- real scalar or NaN if either argument is invalid 
%           or convergenece failed.
%
%   Arguments:
%       x    -- real scalar |x|<=1
%       m    -- real scalar, parameter -inf < m <= 1/x^2
%
%   Functions called:
%       rf, rd
%
%   Matlab functions called:
%       abs, asin, isinf, isnan
%
%   Reference:
%   [1] B.C.Carlson,"Numerical computation of real or complex elliptic 
%       integrals", Numerical Algorithms 10, 1995, pp 13-26.
%   [2] B.C.Carlson, "Elliptic Integrals" In: F.W.J.Olver et al., NIST
%       Handbook of Mathematical Functions, Chap.19, Cambridge, 2010.
%       Handbook of Mathematical Functions, Cambridge, 2010.
%

    % Check input
    
    if nargin == 1
        result = mcelE(x);
        return
    end    
    
    if isnan(x) || isnan(m) || abs(x) > 1
        result = NaN;
        return
    end
    
    % Special cases

    if isinf(m)
        result = m;
        return
    end
    
    if x == 0
        result = 0;
        return
    end
    
    if abs(x) == 1
        result = sign(x)*mcelE(m);
        return
    end
    
    if m == 0
        result = asin(x);
        return
    end
    
    if m == 1
        result = x;
        return
    end
    
    % General case ([2] Eq 19.25.9, 19.25.10, 19.25.11)
    
    x2 = x^2;
    p = (1 - x)*(1 + x);
    q = 1 - m*x2;
    if q < 0
        result = NaN;
    else
        if m < 0
            result = x*(rf( p, q, 1) - (m*x2*rd( p, q, 1))/3);
        elseif m < 1
            result = x*((1 - m)*rf( p, q, 1) + ...
                (m*(1 - m)*x2*rd( p, 1, q))/3 +  m*sqrt(p/q));
        else
            result = x*((m - 1)*x2*rd( q, 1, p)/3 + sqrt(q/p));
        end
    end
    
end



