function result = ufun2( fun, x, y)
%UFUN2 Mimics an elemental behaviour of function FUN with two arguments.
%
%   Result:
%       ufun2( @fun, x, y) -- real scalar, vector or matrix
%
%   Arguments:
%       fun( x, y) -- function return real scalar or NaN
%       x          -- real scalar, vector or matrix
%       y          -- real scalar, vector or matrix 
%
   
    % Check input
    
    if ~isreal(x) || ~isreal(y)
        error('Input arguments must be real.');
    end
    
    % Two scalars
    
    if isscalar(x) && isscalar(y)
        result = fun( x, y);
        return
    end
    
    % One vector argument
    
    if isvector(x) && isscalar(y)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y);
        end
        return
    end
    
    if isscalar(x) && isvector(y)
        [m, n]  = size(y);        
        result = zeros(m,n);
        for i = 1:length(y)
            result(i) = fun( x, y(i));
        end
        return
    end
    
    % Two vectors arguments
    
    if isvector(x) && isvector(y) && isequal(size(x),size(y))
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y(i));
        end
        return
    end

    % One matrix argument
        
    if ismatrix(x) && isscalar(y)
        [m, n] = size(x);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x(i,j), y);
            end
        end
        return
    end
    
    if ismatrix(y) && isscalar(x)
        [m, n] = size(y);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x, y(i,j));
            end
        end
        return
    end
    
    % Two matrix arguments
    
    if ismatrix(x) && ismatrix(y) && isequal(size(x),size(y))
        [m, n] = size(x);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x(i,j), y(i,j));
            end
        end
        return
    end

    error('Arguments must be the same size.')
    
end

