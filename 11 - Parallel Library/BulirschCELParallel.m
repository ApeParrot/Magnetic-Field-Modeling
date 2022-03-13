%% Computation of the generalized complete elliptic integral
 % The implementation here shown is the one found in the article of Derby
 % and Olbert (2009). It is a BASIC version of an algorithm proposed by 
 % Bulirsch (1965) that computes the generalized complete elliptic 
 % integrals.
 %
 %    Inputs:
 %    1) kc    :                                              array [NxM]
 %    2) p     :                                              array [NxM] 
 %    3) a     :                                              array [NxM]
 %    4) b     :                                              array [NxM]
 %    5) Tol   : tolerance of the result                      array [NxM]
 %
 %    Outputs:
 %    1) C(kc,p,a,b) : result of the generalized complete ellitic integral     
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
 %
 % Notes: 
 %
 % 1) For computational efficiency, this routine assumes that p > 0,
 % which is always true in the computation of the magnetic field and
 % magnetic field gradient of permanent magnet cylinders with generic 
 % magnetization. 
 %
 % 2) Notably, the boolean condition sum( abs(g-k) > g*eps ) > 0 ensures 
 % that algorithm converges when ALL the entries NxM have converged 
 % according to the condition abs(g-k) > g*eps.
 %
 % ---------------------------------------------------------------------
 % February 9th, 2022                            Author: Federico Masiero
 % ---------------------------------------------------------------------
 
 %                                         Last check: February 9th, 2022
 
 
function C = BulirschCELParallel(kc,p,a,b,Tol)
 
size_kc = size(kc);
size_p  = size(p);
size_a  = size(a);
size_b  = size(b);

% Check input size congruence 
if ~isequal(size_kc,size_p,size_a,size_b)
    error("Inputs kc, p, a and b should have the same size!")
end

% Reshape inputs to column-wise vectors
kc = kc(:);
p  = p(:);
a  = a(:);
b  = b(:);

eps = Tol;

k  = abs(kc);
pp = p;
aa = a;
em = ones(size(kc));
pp = sqrt(pp);
bb = b./pp;

f  = aa;
aa = aa + bb./pp;
g  = k./pp;
bb = 2*(bb + f.*g);
pp = g + pp;
g  = em;
em = k + em;
kk = k;

while ( sum( abs(g-k) > g*eps ) > 0 )
    
    k  = 2*sqrt(kk);
    kk = k.*em;
    f  = aa;
    aa = aa + bb./pp;
    g  = kk./pp;
    bb = 2*(bb + f.*g);
    pp = g + pp;
    g  = em;
    em = k + em;
    
end

C = (pi/2)*(bb + aa.*em)./(em.*(em + pp));

% result is reshaped based on the size of the inputs
C = reshape(C,size_kc);