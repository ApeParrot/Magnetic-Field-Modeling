function result = mHeumanLambda( BETA, M )
%MHEUMANLAMBDA  Heuman's Lambda function. 
%   MPHEUMANLAMBDA(BETA,K) is the Heuman's lambda function of the elements
%   of BETA (parametric angle) and M (param.). BETA and M must be real and 
%   the same size or any of them can be scalar.

%   See also
%       HeumanLambda

%   MHEUMANLAMBDA is interface function which mimics the elemental 
%   behaviour of function mhlambda.

%   Functions called:
%       mhlambda, ufun2

    if nargin < 2
        error('Not enough input arguments.');
    end
    
    result = ufun2(@mhlambda, BETA, M);
       
end

