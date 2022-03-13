function  result = cel( kc, p, a, b )
%CEL Evaluates the Bulirsch's general complete elliptic integral
%
%           inf
%           | |  
%           |            (a + b*t^2) dt
%   cel =   |  ------------------------------------------
%           |  (1 + p*t^2)*sqrt((1 + t^2)*(1 + kc^2*t^2)) 
%         | | 
%          0
%
%   Result:
%       cel(kc,p,a,b) --- real scalar or NaN if either argument is invalid 
%           or convergence failed. For p<0 the result is Cauchy principal 
%           value
%
%   Arguments: 
%       kc   -- real scalar, complementary modulus 
%       p    -- real scalar
%       a, b -- real scalars
%
%   Functions called:
%       NONE
%
%   Matlab functions called:
%       abs, pi, sqrt
%
%   References:
%   [1] R. Bulirsch -- Numerical calculation of elliptic integrals and 
%       elliptic functions. III, Numerische Mathematik 13, 1969, pp 305-315
%
   
    % Check input
    
    if isnan(kc) || isnan(p) || isnan(a) || isnan(b)
        result = NaN;
        return
    end
    
    if p == 0
        result = NaN;
        return
    end
      
    % Special cases
    
    if isinf(kc) || isinf(p) || (a == 0 && b == 0)
        result = 0;
        return
    end  
        
    kc = abs(kc);
    
    if kc == 1  % calculated by Maple
        if p == 0
            result = sign(b)*inf;
            return
        end
    end
           
    if  kc == 0 
        if b~= 0
            result = inf;
            return
        end
        % here b == 0
        if p == 0
            result = NaN;
            return
        end
        if p == 1
            result = a;
            return
        end
        kc = 0.5e-10; % set by tests (see [1] pp 308 where kc = 10^(-D))
    end

    % General case is translation of Algol procedure cel from [1].

    % D = 16;         % number of significant digits 
    % CA = 10^(-D/2); % relative error    
    
    CA = 1e-8;
    
    e = kc;
    m = 1;
    if p > 0
        p = sqrt(p);
        b = b/p;
    else
        f = kc*kc;
        q = 1 - f;
        g = 1 - p;
        f = f - p;
        q = (b - a*p)*q;
        p = sqrt(f/g);
        a = (a - b)/g;
        b = a*p - q/(g*g*p);
    end

    while true
        f = a;
        a = b/p + a;
        g = e/p;
        b = f*g + b;
        b = b + b;
        p = g + p;
        g = m;
        m = kc + m;
        if abs(g - kc) <= CA*g 
            break
        end
        if isinf(kc) || kc == 0
            result = NaN;
            return
        end  
        kc = sqrt(e);
        kc = kc + kc;
        e  = kc*m;       
    end
    
    result = pi/2*(a*m + b)/(m*(m + p));

end

