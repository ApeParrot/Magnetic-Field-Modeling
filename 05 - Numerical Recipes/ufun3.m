function  result = ufun3( fun, x, y, z)
%UFUN3 Mimics an elemental behaviour of function FUN with three arguments.
%
%   Result:
%       ufun3( @fun, x, y, z) -- real scalar, vector or matrix
%
%   Arguments:
%       fun(x,y,z) -- function return real scalar or NaN
%       x, y, z    -- real scalars, vectors or matrices
%

    % Check input

    if ~isreal(x) || ~isreal(y) || ~isreal(z)
        error('Input arguments must be real.');
    end

    % Three scalars
    
    if isscalar(x) && isscalar(y) && isscalar(z)
        result = fun( x, y, z);
        return
    end

    % One vector

    if isvector(x) && isscalar(y) && isscalar(z)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y, z);
        end
        return
    end
    if isscalar(x) && isvector(y) && isscalar(z)
        [m, n] = size(y);
        result = zeros(m,n);
        for i = 1:length(y)
            result(i) = fun( x, y(i), z);
        end
        return
    end
    if isscalar(x) && isscalar(y) && isvector(z)
        [m, n] = size(z);
        result = zeros(m,n);
        for i = 1:length(z)
            result(i) = fun( x, y, z(i));
        end
        return
    end

    % Two vectors
    
    if isvector(x) && isvector(y) && isequal(size(x),size(y)) && ...
            isscalar(z)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y(i), z);
        end
        return
    end

    if isvector(x) && isvector(z) && isequal(size(x),size(z)) && ...
            isscalar(y)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y, z(i));
        end
        return
    end

    if isvector(y) && isvector(z) && isequal(size(y),size(z)) && ...
            isscalar(x)
        [m, n] = size(y);
        result = zeros(m,n);
        for i = 1:length(y)
            result(i) = fun( x, y(i), z(i));
        end
        return
    end

    % Three vector arguments

    if isvector(x) && isvector(y) && isvector(z) && ...
        isequal(size(x),size(y)) && isequal(size(y),size(z))
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y(i), z(i));
        end
        return
    end

    % One matrix

    if ismatrix(x) && isscalar(y) && isscalar(z)
        [m, n] = size(x);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x(i,j), y, z);
            end
        end
        return
    end
    if isscalar(x) && ismatrix(y) && isscalar(z)
        [m, n] = size(y);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x, y(i,j), z);
            end
        end
        return
    end
    
    if isscalar(x) && isscalar(y) && ismatrix(z)
        [m, n] = size(z);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x, y, z(i,j));
            end
        end
        return
    end
    
    % Two matrix arguments

    if ismatrix(x) && ismatrix(y) && isequal(size(x),size(y)) && ...
            isscalar(z)
        [m, n] = size(x);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x(i,j), y(i,j), z);
            end
        end
        return
    end

    if ismatrix(x) && ismatrix(z) && isequal(size(x),size(z)) && ...
            isscalar(y)
        [m, n] = size(x);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x(i,j), y, z(i,j));
            end
        end
        return
    end

    if ismatrix(y) && ismatrix(z) && isequal(size(y),size(z)) && ...
            isscalar(x)
        [m, n] = size(y);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x, y(i,j), z(i,j));
            end
        end
        return
    end

    % Three matrices
    
    if ismatrix(x) && ismatrix(y) && ismatrix(z) && ...
            isequal(size(x),size(y)) && isequal(size(y),size(z))
        [m, n] = size(x);
        result = zeros(m,n);
        for j = 1:n
            for i = 1:m
                result(i,j) = fun( x(i,j), y(i,j), z(i,j));
            end
        end
        return
    end

    error('Arguments must be the same size.')

end

