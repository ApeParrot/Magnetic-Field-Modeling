function result = elK( k )
%ELK  Evaluates the complete elliptic integral of the 1st kind
%
%                1
%               | |  
%               |              dt
%       K(k) =  |  ------------------------------
%               |  sqrt((1 - t^2)*(1 - k^2*t^2)) 
%             | | 
%              0
%
%   Result:
%       K(k) -- real scalar or NaN if argument is invalid or 
%           convergence failes. 
%
%   Arguments:
%       k  -- real scalar, modulus |k|<=1
%
%   Functions called:
%      melK 
%

    result = melK(k^2);

end


