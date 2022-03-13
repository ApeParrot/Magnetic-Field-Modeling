function result = HeumanLambda( BETA, K )
%HEUMANLAMBDA  Heuman's Lambda function (Heuman's form of complete 
%   elliptic integral of the 3rd kind). 
%   HEUMANLAMBDA(BETA,K) is the Heuman's lambda function of the elements of
%   BETA (parametric angle) and K (modulus). Phi and K must be real and the same
%   size or any of them can be scalar.

%   See also
%       

%   HEUMANLAMBDA is interface function which mimics the elemental 
%   behaviour of function hlambda.

%   Functions called:
%       hlambda, ufun2

    if nargin < 2
        error('Not enough input arguments.');
    end
    
    result = ufun2(@hlambda, BETA, K);
       
end

