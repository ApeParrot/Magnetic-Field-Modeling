function result = elE( x, k )
%ELE Evaluates the complete or the incomplete elliptic integrals 
%   of the 2nd kind
%
%                  x
%                 | |  
%                 |  sqrt(1 - k^2*t^2)
%       E(x,k) =  |  ----------------- dt
%                 |  sqrt(1 -    t^2) 
%               | | 
%                0
%
%   Result:
%       E(k)   -- (complete integral) real scalar or NaN if either 
%           argument is invalid or convergenece failed. 
%       E(x,k) -- (incomplete integral) real scalar or NaN if either 
%           argument is invalid or convergenece failed.
%
%   Arguments:
%       x    -- real scalar, |x|<= 1
%       k    -- real scalar, modulus |k*x| <= 1
%
%   Functions called:
%       melE

    if nargin == 1
        result = melE(x^2); % k = x !!
    else
        result = melE( x, k^2);
    end
 
end



