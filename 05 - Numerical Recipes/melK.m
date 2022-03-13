function result = melK( m )
%MELK  Evaluates the complete elliptic integral of the 1st kind
%
%                1
%               | |  
%               |              dt
%       K(m) =  |  ---------------------------
%               |  sqrt((1 - t^2)*(1 - m*t^2)) 
%             | | 
%              0
%
%   Result:
%       K(m) -- real scalar or NaN if either argument is invalid or 
%           convergence failes.
%
%   Arguments:
%       m  -- parameter, real scalar -inf < m <= 1
%
%   Functions called:
%      rf 
%
%   Matlab functions called:
%       abs, isinf, isnan, pi, sqrt
%
%   Reference:
%   [1] B.C.Carlson,"Numerical computation of real or complex elliptic 
%       integrals", Numerical Algorithms 10, 1995, pp 13-26.
%

    % Check input
    
    if isnan(m) || m > 1
        result = NaN;
        return
    end
    
    % Specila cases (Maple)
    
    if m == 0
        result = pi/2;
        return
    end
    
    if m == 1
        result = inf;
        return
    end
    
    if isinf(m)
        result = 0;  
        return
    end
       
    % there is no big difference if these special cases are used or not
    
    % This works up to 1-1e-13. There are problems in the range 
    %   0.9999 - 0.99999 where accurracy falls to 12D, and then again
    %   increase to 15D (comparing with ellipticK). If one use only first
    %   term result is accured to about 10D.
    if m > 0.9999
        m1 = 1 - m;
        a = 0.5*log(16/m1);
        result = a + m1*(0.25*(a - 1) + m1*((9*(6*a - 7))/(6*64))); % + ...
           % m1*(25*(30*a - 37)/(30*256))));
      return
    end
    
    if abs(m) < 1e-3
        result = (pi/2)*(1 + m*(1/4 + m*(9/64 + m*(25/256 + m*1225/16384))));
        return
    end

    if m < -3e6
        a = log(-16*m)/2;
        b = sqrt(-m);
        result = (a - (a - 1)/(-m)/4 + 9*(a - 7/6)/64/(-m^2))/b ;
        return
    end
    
    % General case ([1] Eq 4.5)
       
    result = rf( 0, 1 - m, 1);
    
end


