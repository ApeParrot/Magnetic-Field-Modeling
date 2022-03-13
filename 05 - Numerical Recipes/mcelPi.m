function result = mcelPi( nu, m)
%MCELPI Evaluates the complete elliptic integrals of the 3rd kind 
%
%                 1
%                | |  
%                |                    dt
%    Pi(nu,m) =  |  ---------------------------------------
%                |  (1 - nu*t^2)*sqrt((1 - t^2)*(1 - m*t^2)) 
%              | | 
%               0
%
%   Result:
%       mcelPi(n,m) -- real scalar or NaN if either argument is invalid 
%           or convergenece failed.
%
%   Arguments:
%       nu   -- real scalar, characteristic <= 1
%       m    -- real scalar, parameter <= 1
%
%   Functions called:
%       rf, rj, melK
%
%   Matlab functions called:
%       abs, isinf, isnan, log, sqrt, pi
%
%   Reference:
%   [1] B.C.Carlson,"Numerical computation of real or complex elliptic 
%       integrals", Numerical Algorithms 10, 1995, pp 13-26.
%   [2] B.C.Carlson, "Elliptic Integrals" In: F.W.J.Olver et al., NIST 
%       Handbook of Mathematical Functions, Cambridge, 2010.
%

    % Check input

    if isnan(nu) || isnan(m) || nu > 1 || m > 1 
        result = NaN;
        return
    end

    % Special cases 
    
    if isinf(m) || isinf(nu)  % http://functions.wolfram.com/PDF/EllipticPi3.pdf
        result = 0; 
        return
    end
    
    if nu == 1 || m == 1
        result = inf; % [2] 19.6.11 (3)
        return
    end
    
    if m == 0
        if nu == 0
            result = pi/2; % [2] 19.6.11 (2)        
        else
            result = pi/(2*sqrt(1 - nu));
        end
        return
    end
    
    if nu == 0
        result = melK(m);
        return
    end
    
    % General case ( [1] Eq 4.7, n -> -n !!!!)

    result = rf(0, 1 - m, 1) + nu*rj( 0, 1 - m, 1, 1 - nu)/3;
    
    
end

