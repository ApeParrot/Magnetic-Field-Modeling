%% Computation of the generalized complete elliptic integral
 % Vectorized implementation of the Bulirsch algorithm to compute the
 % generalized complete elliptic integrals when the second argument (p) 
 % contains only positive entries
 %
 %    Inputs:
 %    1) kc    :                                                 [Nx1]
 %    2) p     :                                                 [Nx1] 
 %    3) c     :                                                 [Nx1]
 %    4) s     :                                                 [Nx1]
 %    5) Tol   : tolerance of the result                         [number]
 %
 %    Outputs:
 %    1) C(kc,p,c,s) : result of the generalized complete ellitic integral     
 %                                                               [Nx1]
 %
 
 % ---------------------------------------------------------------------
 % January 3rd, 2020                            Author: Federico Masiero
 % ---------------------------------------------------------------------
 
 %                                         Last check: January 3rd, 2020
 
function C = ParallelBulirsch(kc,p,c,s,Tol)

eps = Tol;

k  = abs(kc);
pp = p;
cc = c;
em = ones(size(kc));
pp = sqrt(pp);
ss = s./pp;

f  = cc;
cc = cc + ss./pp;
g  = k./pp;
ss = 2*(ss + f.*g);
pp = g + pp;
g  = em;
em = k + em;
kk = k;

while ( sum( abs(g-k) > g*eps ) > 0 )
    
    k  = 2*sqrt(kk);
    kk = k.*em;
    f  = cc;
    cc = cc + ss./pp;
    g  = kk./pp;
    ss = 2*(ss + f.*g);
    pp = g + pp;
    g  = em;
    em = k + em;
    
end

C = (pi/2)*(ss + cc.*em)./(em.*(em + pp));