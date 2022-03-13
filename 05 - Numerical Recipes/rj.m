function  result  = rj( x, y, z, p )
%RJ Evaluates the Carlson's elliptic integral of the 3th kind [1]
%
%                         inf
%                         | |  
%                     3   |                 dt
%       rj(x,y,z,p) = -   |  -------------------------------------
%                     2   |  (t + p)*sqrt((t + x)*(t + y)*(t + z)) 
%                       | | 
%                        0
%
%   Result:
%       rj(x,y,z,p) -- real scalar or NaN if either argument is invalid or
%           convergence failed.
%           If p < 0 then result is real part of Cauchy PV.
%
%   Arguments:
%       x,y,z  ---  real scalars >0, at most one can be 0
%       p      ---  real scalar  
%
%   Matlab functions called:
%       abs, isinf, isnan, sqrt
%
%   Functions called:
%       rc
%
%   References:
%   [1] B.C.Carlson,"Numerical computation of real or complex elliptic 
%       integrals", Numerical Algorithms 10, 1995, pp 13-26.
%   [2] B.C.Carlson, "Elliptic Integrals" In: F.W.J.Olver et al., NIST 
%       Handbook of Mathematical Functions, Cambridge, 2010.
%   [3] W.H.Press et al., "Numerical Recipes in Fortran 90", 2nd ed., 
%       Cambridge, 1996
%

    % Check input
    
    if isnan(x) || isnan(y) || isnan(z) || isnan(p)
        result = NaN;
        return
    end
    
    if x < 0 || y < 0 || z < 0 
        result = NaN;
        return
    end
    
    if x + y == 0 || y + z == 0 || z + x == 0
        result = NaN;
        return
    end
       
    % Special cases    
    
    if p == 0
        if x > 0 && y > 0 && z > 0
            % RJ(x,y,z,0)  [2] 19.20.7 x,y,z>0 
            result = inf;
        else
            result = NaN;
        end
        return
    end
    
    if isinf(x) || isinf(y) || isinf(z) || isinf(p)
        result = 0;
        return
    end
       
    % RJ(0,0,z,p)  [2] 19.20.6 (4)
    if (x == 0 && y == 0) || (x == 0 && z == 0) || (y == 0 && z == 0)
        result = inf;               
        return
    end
    
    % RJ(x,x,x,x) [2] 19.20.6 (1)
    if x == y && y == z && z == p
        result = 1/(x*sqrt(x));     
        return
    end
          
    % General case (based on rj_s from [3])
    
    pt = p;
    if pt < 0
        s = x + y + z;
        % Order 0 <= x <= y <= z
        if x > y
            t = x; x = y; y = t;
        end
        if x > z
            t = x; x = z; z = t;
        end
        if y > z
            z = y; %t = y; y = z; z = t;
        end     
        y   = s - x - z;
        a   = 1/(y - p);
        b   = a*(z - y)*(y - x);
        p   = y + b;
        r   = x*z/y;
        t   = p*pt/y;
        rcx = rc(r,t);
    end
    
    ERRTOL = 0.001;  % by tests
    
    sm = 0;
    fc = 1;
    while true
        rx = sqrt(x);
        ry = sqrt(y);
        rz = sqrt(z);
        lm = rx*(ry + rz) + ry*rz;
        ea = (p*(rx + ry + rz) + rx*ry*rz)^2;
        eb = p*(p + lm)^2;
        sm = sm + fc*rc(ea,eb);
        if isnan(sm)
            result = NaN;
            return
        end
        fc = 0.25*fc;
        x  = 0.25*(lm + x);
        y  = 0.25*(lm + y);
        z  = 0.25*(lm + z);
        p  = 0.25*(lm + p);
        av = 0.2*(x + y + z + p + p);
        if isinf(av)
            result = NaN;
            return
        end
        dx = (av - x)/av;
        dy = (av - y)/av;
        dz = (av - z)/av;
        dr = (av - p)/av;
        if abs(dx) < ERRTOL && abs(dy) <ERRTOL && abs(dz) < ERRTOL && ...
                abs(dr) < ERRTOL
            break
        end
    end
    ea = dx*(dy + dz) + dy*dz;
    eb = dx*dy*dz;
    ec = dr*dr;
    ed = ea - 3*ec;
    ee = eb + 2*dr*(ea - ec);
    
    C1  = -3/14;
    C2  =  1/3;
    C3  =  3/22;
    C4  =  3/26;
    C5  =  0.75*C3;
    C6  =  1.5*C4;
    C7  =  0.5*C2;
    C8  = -2*C3;
    s   = ed*(C1 + C5*ed - C6*ee);
    s   = s + eb*(C7 + dr*(C8 + dr*C4)); 
    s   = s + dr*ea*(C2 - dr*C3) - C2*dr*ec;
    
    result  = 3*sm + fc*(1 + s)/(av*sqrt(av));
    
    if pt <= 0
        result = a*(b*result + 3*(rcx - rf(x,y,z)));
    end
    
end


