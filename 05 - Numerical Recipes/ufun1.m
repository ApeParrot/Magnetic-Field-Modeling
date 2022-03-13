function result = ufun1( fun, x)
%UFUN1 Mimics an elemental behaviour of function fun.
%
%   Result:
%       ufun1( @fun, x) -- real scalar or vector
%
%   Arguments:
%       fun( x) -- function return real scalar or NaN
%       x       -- real scalar, vector or matrix
%
   
    % Check input
    
    if ~isreal(x) 
        error('Input arguments must be real.');
    end
    
    % One scalar argument
    
    if isscalar(x)
        result = fun( x);
        return
    end
    
    % One vector argument
    
    if isvector(x)        
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i));
        end
        return
    end
    
    % One matrix argument
    
    if ismatrix(x)
        [m, n] = size(x);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x(i,j));
            end
        end
        return
    end    
    
    error('Argument must be scalar, vector or matrix.')
    
end

