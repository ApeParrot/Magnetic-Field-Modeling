function result = EllipticK( K )
%ELLIPTICK Complete elliptic integral of 1st kind. 
%   ELLIPTICK(K) is complete elliptic integral of elements of modulus K. 
%   The elements of K must all be real.
%
%   See also
%       mEllipticK

%   ELLIPTICK is a wrapper function which mimics the elemental behaviour
%   of function elK.

%   Functions called:
%       elK, ufun1

    if nargin < 1
        error('Not enough input arguments.');
    end
    
    result = ufun1(@elK, K);
    
end

