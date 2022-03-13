function result = elPi( x, nu, k)
%ELPI Evaluates the complete or incomplete elliptic integrals of the 
%   3rd kind 
%
%                 x
%                | |  
%                |                    dt
%   Pi(x,n,k) =  |  ----------------------------------------
%                |  (1 - n*t^2)*sqrt((1 - t^2)*(1 - k^2*t^2)) 
%              | | 
%               0
%
%   Result:
%       Pi(n,k)   -- complete integral, real scalar or NaN if either 
%           argument is invalid or convergenece failed.
%       Pi(x,n,k) -- real scalar or NaN if either argument is invalid 
%           or convergenece failed.
%
%   Arguments:
%       x    -- real scalar, -1 <= x <= 1
%       k    -- real scalar, elliptic modulus, 1-(k*x)^2 >= 0  
%       n    -- real scalar, characteristic, 1-n*x^2 >= 0 
%
%   Functions called:
%       melPi
%
    
    if nargin == 2
        result = melPi( x, nu^2);  % nu = x, k = nu !!!
    else  
        result = melPi( x, nu, k^2);
    end
    
end

