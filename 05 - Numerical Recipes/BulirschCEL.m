function result = BulirschCEL( KC, P, A, B )
%BULIRSCHCEL Bulirsch's general complete elliptic integral CEL.
%   BULIRSCHCEL(KC,P,A,B) is the Bulirsch's general complete elliptic 
%   integral of the elements of KC (complementary modulus), P, A and B. 
%   KC, P, A and B must be real and of the same size or any of them can
%   be scalar.  
%
%   See also
%       BULIRSCHCEL1, BULIRSCHCEL2, BULIRSCHCEL3

%   BULIRSCHCEL is a wrapper function which mimics the elemental behaviour 
%   of function CEL.

%   Functions called:
%       cel, ufun4

    if nargin < 4
        error('Not enough input arguments.');
    end

    result = ufun4(@cel, KC, P, A, B);
    
end

