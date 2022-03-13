function result = rd( x, y, z)
%RD Evaluates the Carlson degenerate case of an elliptic integral of 
%   the 2nd kind [1] 
%
%                       inf
%                       | |  
%                   3   |                  dt
%       rd(x,y,z) = -   |  ------------------------------------
%                   2   |  (t + z)*sqrt((t + x)*(t + y)*(t + z)) 
%                     | | 
%                      0
%
%   Result:
%       rd(x,y,z) -- Real scalar or NaN if either argument is invalid or
%           convergence failed.
%
%   Arguments:
%       x,y    ---  real scalars >0, only one can be zero 
%       z      ---  real scalar  >0 
%
%   Functions called:
%       ell_rc
%
%   Matlab functions called:
%       abs, isinf, isnan, max, sqrt
%
%   References:
%   [1] B.C.Carlson,"Numerical computation of real or complex elliptic 
%       integrals", Numerical Algorithms 10, 1995, pp 13-26.
%   [2] B.C.Carlson, "Elliptic Integrals" In: F.W.J.Olver et al., NIST
%       Handbook of Mathematical Functions, Chap.19, Cambridge, 2010.
%       Handbook of Mathematical Functions, Cambridge, 2010.
%   [3] W.H.Press et al., "Numerical Recipes in Fortran 90", 2nd ed., 
%       Cambridge, 1996
% 

    % Check input

    if isnan(x) || isnan(y) || isnan(z)
        result = NaN;
        return
    end

    if x < 0 || y < 0 || z <= 0 
        result = NaN;
        return
    end
    
    if x + y == 0
        result = NaN;
        return
    end
    
    % Special cases 
    
    if isinf(x) || isinf(y) || isinf(z)
        result = 0; % ???
        return
    end
    
    if x == 0 && y == 0
        result = inf;                       % RD(0,0,z) [2] 19.20.18 (4)     
        return
    end
            
    if y == z
        if x == 0
            result = 3*pi/(4*y*sqrt(y));    % RD(0,y,y) [2] 19.20.18 (3)
            return
        end
        if x == y
            result = 1/(x*sqrt(x));         % RD(x,x,x) [2] 19.20.18 (1)
            return
        end
    end
       
    % General case (based on rd_s from [3])
    
    ERRTOL = 0.002; % By tests

    sm = 0;
    fc = 1;
    while true
        rx = sqrt(x);
        ry = sqrt(y);
        rz = sqrt(z);
        lm  = rx*(ry + rz) + ry*rz;
        sm = sm + fc/(rz*(z + lm));
        fc = 0.25*fc;
        x  = 0.25*(lm + x);
        y  = 0.25*(lm + y);
        z  = 0.25*(lm + z);
        m  = (x + y + 3*z)/5;
        if isinf(m)
            result = NaN;
            return
        end
        dx = (m - x)/m;
        dy = (m - y)/m;
        dz = (m - z)/m;
        if abs(dx) < ERRTOL && abs(dy) < ERRTOL && abs(dz) < ERRTOL
            break
        end
    end
    ea = dx*dy;
    eb = dz*dz;
    ec = ea - eb;
    ed = ea - 6*eb;
    ee = ed + ec + ec;
    
    C1  = -3/14;
    C2  = 1/6;
    C3  = 9/22;
    C4  = 3/26;
    C5  = 9/88;
    C6  = 9/52;
    s   = ed*(C1 + C5*ed - C6*dz*ee);
    s   = s + dz*(C2*ee + dz*(dz*C4*ea - C3*ec));
    
    result  = 3*sm + fc*(1 + s)/(m*sqrt(m));
    
end


