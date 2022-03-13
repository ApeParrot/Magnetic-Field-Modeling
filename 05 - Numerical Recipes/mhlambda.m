function  result = mhlambda( beta, m )
%MHLAMBDA Heuman's Lambda function (complete elliptic integral of the 
% third kind). 
%
%   Lambda(beta,m) = 2/pi*(K(m)*E(beta,m') - (K(m) - E(m))*F(beta,m'))
%
%   Result:
%       mlambda( beta,m) -- real scalar or NaN if either argument is 
%           invalid or convergence filed.
%
%   Arguments:
%       beta -- real scalar, parametric angle
%       m    -- real scalar, parameter -inf < m <= 1
%
%   Functions called:
%       cel, umodpi
%
%   Matlab functions called:
%       abs, isinf, isnan, pi, sign, sin, sqrt, tan
%
%   References:
%   [1] R. Bulirsch, "Numerical calculation of elliptic integrals and 
%       elliptic functions. III", Numerische Mathematik 13, 1969, 
%       pp 305 - 315
%   [2] W.Ehrhardt, "The AMath and DMath Special functions", 2016
%   [3] C. Heuman, Tables of Complete Elliptic Integrals, J Math Phys Camb,
%       20 (1941) 127-206.

    % Check input
    
    if isnan(beta) || isinf(beta) || isnan(m) || isinf(m) || m > 1 
        result = NaN;
        return
    end

    % Special cases

    if m < 0 && abs(beta) > asin(1/sqrt(1 - m))
        result = NaN;
        return
    end
    
    if beta == 0
        result = 0;
        return
    end

    if m == 1
        result = 2*beta/pi;
        return
    end
    
    % General case is based on Pascal procedure heuman_lambda from AMath
    % [2]
    
    s = sign(beta);
    [a, x] = umodpi(beta);  
    
    if x == 0 
        result = s*a;
        return
    end

    % [1] Eq 1.2.3
    t = 1 - m;
    p = 1 + m*(tan(x))^2;
    if p < 0 
        result = NaN;
        return
    end
    x = sin(x)*sqrt(p)/(pi/2);
    t = cel(sqrt(t), p, 1, t);
    
    result = s*(a + t*x);

end

