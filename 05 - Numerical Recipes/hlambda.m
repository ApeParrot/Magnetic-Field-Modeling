function  result = hlambda( beta, k )
%HLAMBDA Heuman's lambda function (Heuman's form of complete 
%   elliptic integral of the 3rd kind)
%
%   Lambda0(beta,k) = 2/pi*(K(k)*E(phi,k') - (K(k) - E(k))*F(phi,k'))
%
%   Result:
%       lambda( beta,k) -- real scalar or NaN if either argument is 
%           invalid or convergence filed.
%
%   Arguments:
%       beta -- real scalar, parameter angle
%       k   -- real scalar, modulus |k|<=1
%
%   Functions called:
%       mhlambda

    result = mhlambda( beta, k^2);
    
end

