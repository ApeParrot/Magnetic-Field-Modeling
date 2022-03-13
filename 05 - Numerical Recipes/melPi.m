function result = melPi( x, nu, m)
%MELPI Evaluates the incomplete elliptic integrals of the 3rd kind ([2]
%   19.2.7)
%
%                  x
%                 | |  
%                 |                    dt
%   Pi(x,nu,m) =  |  ---------------------------------------
%                 |  (1 - nu*t^2)*sqrt((1 - t^2)*(1 - m*t^2)) 
%               | | 
%                0
%
%   Result:
%       Pi(x,n,m) -- real scalar or NaN if either argument is invalid 
%           or convergenece failed.
%
%   Arguments:
%       x    -- real scalar |x|<=1
%       nu   -- real scalar, characteristic 1 - n*x^2 >= 0
%       m    -- real scalar, parameter  1 - m*x^2 >= 0
%
%   Functions called:
%       rf, rj
%
%   Matlab functions called:
%       abs, asin, atanh, isinf, isnan, log, sqrt
%
%   Reference:
%   [1] B.C.Carlson,"Numerical computation of real or complex elliptic 
%       integrals", Numerical Algorithms 10, 1995, pp 13-26.
%   [2] B.C.Carlson, "Elliptic Integrals" In: F.W.J.Olver et al., NIST 
%       Handbook of Mathematical Functions, Cambridge, 2010.
%

    % Check input
    
    if nargin == 2
        result = mcelPi( x, nu);
        return
    end    
    
    if isnan(x) || isnan(m) || isnan(nu) || abs(x) > 1
        result = NaN;
        return
    end
    
    % Special cases 

    if x == 0
        result = 0; % % [2] 19.6.11 (1)
        return
    end
    
    if abs(x) == 1
        result = sign(x)*mcelPi(nu,m);
        return
    end
    
    if nu == 0 && m == 0
        result = asin(x); % [2] 19.6.11 (2)
        return
    end
    
    if nu == 0 && m == 1
        result = atanh(x); % [2] 19.6.11 (3)
        return
    end

    if nu == 1 && m == 0
        result = x/sqrt((1 - x)*(1 + x)); % Maple
        return
    end

    if nu == 1 && m == 1
        % Maple
        p = log((1 + x)/(1 - x));
        q = 2*x/((1 - x)*(1 + x));
        result = (p + q)/4;
        return
    end
    
    if nu == 0
        result = melF(x,m);
        return
    end
    
    if isinf(m) || isinf(nu)
        result = 0; % Maple
        return
    end
       
   
    % General case ( [1] Eq 4.7, n -> -n !!!!)
    
    x2 = x*x;   
    p  = (1 - x)*(1 + x);
    q  = 1 - m*x2;
    r  = 1 - nu*x2;
    if  q < 0 || r < 0
        result = NaN;
        return
    end

    result = x*(rf( p, q, 1) + nu*x2*rj( p, q, 1, r)/3);
    
end

