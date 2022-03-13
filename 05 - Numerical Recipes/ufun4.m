function  result  = ufun4( fun, x, y, z, p)
%UFUN3 Mimics an elemental behaviour of function FUN with four arguments.
%
%   Result:
%       ufun4( @fun, x, y, z, p) -- real scalar, vector or matrix
%
%   Arguments:
%       fun(x,y,z,p) -- function return real scalar or NaN
%       x,y,z,p      -- real scalars, vectors or matrices
%

    % Check input
    
    if ~isreal(x) || ~isreal(y) || ~isreal(z) || ~isreal(p)
        error('Input arguments must be real.');
    end

    % Four scalar arguments
    
    if isscalar(x) && isscalar(y) && isscalar(z) && isscalar(p)
        result = fun( x, y, z, p);
        return
    end

    % One vector argument

    if isvector(x) && isscalar(y) && isscalar(z) && isscalar(p)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y, z, p);
        end
        return
    end

    if isscalar(x) && isvector(y) && isscalar(z) && isscalar(p)
        [m, n] = size(y);
        result = zeros(m,n);
        for i = 1:length(y)
            result(i) = fun( x, y(i), z, p);
        end
        return
    end

    if isscalar(x) && isscalar(y) && isvector(z) && isscalar(p)
        [m, n] = size(z);
        result = zeros(m,n);
        for i = 1:length(z)
            result(i) = fun( x, y, z(i), p);
        end
        return
    end

    if isscalar(x) && isscalar(y) && isscalar(z) && isvector(p)
        [m, n] = size(p);
        result = zeros(m,n);
        for i = 1:length(p)
            result(i) = fun( x, y, z, p(i));
        end
        return
    end

    % two vector arguments

    if isvector(x) && isvector(y) && length(x) == length(y) && ...
            isscalar(z) && isscalar(p)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y(i), z, p);
        end
        return
    end

    if isvector(x) && isvector(z) && length(x) == length(z) && ...
            isscalar(y) && isscalar(p)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y, z(i), p);
        end
        return
    end
    
    if isvector(x) && isvector(p) && length(x) == length(p) && ...
            isscalar(y) && isscalar(z)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y, z, p(i));
        end
        return
    end
    
    if isvector(y) && isvector(z) && length(y) == length(z) && ...
            isscalar(x) && isscalar(p)
        [m, n] = size(y);
        result = zeros(m,n);
        for i = 1:length(y)
            result(i) = fun( x, y(i), z(i), p);
        end
        return
    end

    if isvector(y) && isvector(p) && length(y) == length(p) && ...
            isscalar(x) && isscalar(z)
        [m, n] = size(y);
        result = zeros(m,n);
        for i = 1:length(y)
            result(i) = fun( x, y(i), z, p(i));
        end
        return
    end
    
    if isvector(z) && isvector(p) && length(z) == length(p) && ...
            isscalar(x) && isscalar(y)
        [m, n] = size(z);
        result = zeros(m,n);
        for i = 1:length(z)
            result(i) = fun( x, y, z(i), p(i));
        end
        return
    end    
    
    % three vector arguments

    if isvector(x) && isvector(y) && length(x) == length(y) && ...
            isvector(z) && length(x) == length(z) && isscalar(p)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y(i), z(i), p);
        end
        return
    end
    
    if isvector(x) && isvector(y) && length(x) == length(y) && ...
            isvector(p) && length(x) == length(p) && isscalar(z)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y(i), z, p(i));
        end
        return
    end    

    if isvector(x) && isvector(z) && length(x) == length(z) && ...
            isvector(p) && length(x) == length(p) && isscalar(y)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y, z(i), p(i));
        end
        return
    end 
    
    if isvector(y) && isvector(z) && length(y) == length(z) && ...
            isvector(p) && length(y) == length(p) && isscalar(x)
        [m, n] = size(y);
        result = zeros(m,n);
        for i = 1:length(y)
            result(i) = fun( x, y(i), z(i), p(i));
        end
        return
    end     

    % four vector arguments

    if isvector(x) && ...
            isvector(y) && length(x) == length(y) && ...
            isvector(z) && length(x) == length(z) && ...
            isvector(p) && length(x) == length(p)
        [m, n] = size(x);
        result = zeros(m,n);
        for i = 1:length(x)
            result(i) = fun( x(i), y(i), z(i), p(i));
        end
        return
    end
    
    % two matrix arguments
    
     if ismatrix(x) && ismatrix(y) && isequal(size(x),size(y)) && ...
             isscalar(z) && isscalar(p)
         [m, n] = size(x);
         result = zeros(m,n);
         for j = 1:n
             for i = 1:m
                 result(i,j) = fun( x(i,j), y(i,j), z, p);
             end
         end
         return
     end
     
     if ismatrix(x) && ismatrix(z) && isequal(size(x),size(z)) && ...
             isscalar(y) && isscalar(p)
         [m, n] = size(x);
         result = zeros(m,n);
         for j = 1:n
             for i = 1:m
                 result(i,j) = fun( x(i,j), y, z(i,j), z, p);
             end
         end
         return
     end
     
     if ismatrix(x) && ismatrix(p) && isequal(size(x),size(p)) && ...
             isscalar(y) && isscalar(z)
         [m, n] = size(x);
         result = zeros(m,n);
         for j = 1:n
             for i = 1:m
                 result(i,j) = fun( x(i,j), y, z, p(i,j));
             end
         end
         return
     end
     
     if ismatrix(y) && ismatrix(z) && isequal(size(y),size(z)) && ...
             isscalar(x) && isscalar(p)
         [m, n] = size(y);
         result = zeros(m,n);
         for j = 1:n
             for i = 1:m
                 result(i,j) = fun( x, y(i,j), z(i,j), p);
             end
         end
         return
     end     
     
     if ismatrix(y) && ismatrix(p) && isequal(size(y),size(p)) && ...
             isscalar(x) && isscalar(z)
         [m, n] = size(y);
         result = zeros(m,n);
         for j = 1:n
             for i = 1:m
                 result(i,j) = fun( x, y(i,j), z, p(i,j));
             end
         end
         return
     end      
    
     if ismatrix(z) && ismatrix(p) && isequal(size(z),size(p)) && ...
             isscalar(x) && isscalar(y)
         [m, n] = size(z);
         result = zeros(m,n);
         for j = 1:n
             for i = 1:m
                 result(i,j) = fun( x, y, z(i,j), p(i,j));
             end
         end
         return
     end     
     
    error('Arguments must be the same size.')
    
end

