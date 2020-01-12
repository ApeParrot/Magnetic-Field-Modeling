%% Computation of the generalized complete elliptic integral
 % The implementation here shown is the one found in the article of Derby
 % and Olbert (2009). It is a BASIC version of an algorithm proposed by 
 % Bulirsch (1965) that computes the generalized complete elliptic 
 % integrals.
 %
 %    Inputs:
 %    1) kc    :                                                 [number]
 %    2) p     :                                                 [number] 
 %    3) c     :                                                 [number]
 %    4) s     :                                                 [number]
 %    5) Tol   : tolerance of the result                         [number]
 %
 %    Outputs:
 %    1) C(kc,p,c,s) : result of the generalized complete ellitic integral     
 %                                                               [number]
 %
 % One may varify the equivalence with the built-in MATLAB functions  
 % ellipke and ellipticPi in the following cases:
 % Given the values kc and n in [0,1]
 % [K E] = ellipke(1-kc^2);      ---->  K  = C(kc,1,1,1) 
 %                               ---->  E  = C(kc,1,1,kc^2)
 % PI    = ellipticPi(n,1-kc^2)  ---->  PI = C(kc,1-n,1,1)
 %
 % Computing these integrals with this function is much more efficient than
 % the built-in ones (expecially of EllipticPi)!
 
 % ---------------------------------------------------------------------
 % August 22nd, 2019                            Author: Federico Masiero
 % ---------------------------------------------------------------------
 
 %                                          Last check: October 6th, 2019
 
 
function C = GeneralizedEllipke(kc,p,c,s,Tol)
 
if (kc == 0)
    C = Inf;
    return
end

eps = Tol;   % error tolerance

k  = abs(kc);
pp = p;
cc = c;
ss = s;
em = 1;

if p > 0
    pp = sqrt(p);
    ss = s/pp;
else
    f  = kc*kc;
    q  = 1 - f;
    g  = 1 - pp;
    f  = f - pp;
    q  = q*(ss - c*pp);
    pp = sqrt(f/g);
    cc = (c - ss)/g;
    ss = cc*pp - q/(g*g*pp);
end

f  = cc;
cc = cc + ss/pp;
g  = k/pp;
ss = 2*(ss + f*g);
pp = g + pp;
g  = em;
em = k + em;
kk = k;

while ( abs(g-k) > g*eps )
    
    k  = 2*sqrt(kk);
    kk = k*em;
    f  = cc;
    cc = cc + ss/pp;
    g  = kk/pp;
    ss = 2*(ss + f*g);
    pp = g + pp;
    g  = em;
    em = k + em;
    
end

C = (pi/2)*(ss + cc*em)/(em*(em + pp));