function result = mcelE( m )
%CELE Evaluates the complete elliptic integrals of the 2nd kind
%
%              1
%             | |  
%             |  sqrt(1 - m*t^2)
%     E(m) =  |  --------------- dt
%             |  sqrt(1 -   t^2) 
%           | | 
%            0
%
%   Result:
%       E(m) -- real scalar or NaN if either argument is invalid 
%           or convergenece failed.
%
%   Arguments:
%       m    -- real scalar, parameter -inf < m <= 1
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
%

    % Check input
    
    if isnan(m) || m > 1
        result = NaN;
        return
    end
    
    % Special cases (Maple)
    
    if isinf(m) || m < -1e308
        result = inf; 
        return
    end

    if m == 0
        result = pi/2;
        return
    end
    
    if m == 1
        result = 1;
        return
    end
    
    %%{
    if m < -2e6
        b = log(-16*m);
        a = sqrt(-m);
        result = a + 1/4*(b + 1)/a - 1/32*(b - 3/2)/a^3;
        return
    end
    %}
    
    %{
    if abs(m) < 1e-3  % aerr < 2.68e-17
        result = (pi/2)*(1 - m*(1/4 + m*(3/64 + m*(5/256 + 175/16384*m))));
        return
    end
    %}
    
    %%{
    if m > 0.999999999999 % 1-1/10^12 
        m1 = 1 - m;
        a = log(16/m1);
        result = 1 +  m1*0.25*(a - 1);
        return
    end
    %}
    
    % General case ([1] Eq 4.6)

    result = 2*rg(0,1 - m,1); 

end



