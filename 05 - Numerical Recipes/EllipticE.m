function result = EllipticE( X, K )
%ELLIPTICE  Jacobi form of the elliptic integral of the second kind. 
%   ELLIPTICE(X,K) is  elliptic integral of the elements of X and K
%   (modulus). X and K must be real and of the same size or any of them
%   can be scalar.  
%
%   ELLIPTICE(K) is  complete elliptic integral of the elements of K
%   (modulus). K must be real.

%   See also
%       mEllipticE

%   ELLIPTICE is a wrapper function which mimics the elemental behaviour
%   of function elE and celE.

%   Functions called:
%       elE, ufun1, ufun2

    if nargin < 1
        error('Not enough input arguments.');
    end

    if nargin == 1
        result = ufun1(@elE, X);
    else
        result = ufun2( @elE, X, K);
    end
    
end

