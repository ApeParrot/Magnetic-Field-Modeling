function result = EllipticPi( X, N, K )
%ELLIPTICPI  Elliptic integral of the 3rd kind (Jacobi form). 
%   ELLIPTICPI(X,N,K) is the Jacobi's form of  elliptic integral of the
%   3rd kind of elements of X, N and modulus K. X, N and K must be real and 
%   of the same size or any of them can be real scalar. 
%
%   ELLIPTICPI(N,K) is complete elliptic integral of the 3rd kind of the 
%   elements of N (characteristic) and K (modulus). N and K must be real.
%
%   See also
%       mEllipticPi

%   ELLIPTICPI is interface function which mimics the elemental behaviour
%   of function elPi and celPi.

%   Functions called:
%       elPi, ufun2, ufun3

    if nargin < 2
        error('Not enough input arguments.');
    end
    
    if nargin == 2
        result = ufun2(@elPi, X, N);
    else
        result = ufun3(@elPi, X, N, K);
    end
    
end

