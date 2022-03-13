function [ m, x ] = umodpi( z )
%UMODPI Reduce |z| mod pi, |z| = m*pi/2 + x
%
%   Matlab functions called:
%       abs, ceil, eps, floor, pi
%
%   References:
%   [1] W.Ehrhardt, "The AMath and DMath Special functions", 2016

%   Based on Pascal procedure special_reduce_modpi from AMath [1]

    t = abs(z);
    m = fix(t/pi);
    x = t - m*pi;
    n = ceil(eps(m*pi)/eps);
    
    if abs(x) <= n*eps
        m = 2*m;
        x = 0;
    elseif abs(x - pi/2) <= n*eps
        x = 0;
        m = 2*m + 1;
    elseif abs(x - pi) <= n*eps
        x = 0;
        m = 2*m + 2;
    else
        m = 2*m;
        if x > pi/2
            m = m + 2;
            x = x - pi;
        end
    end
    
end

