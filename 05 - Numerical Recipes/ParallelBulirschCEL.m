%% Computation of the generalized complete elliptic integral
 % The implementation here shown is the one found in the article of Derby
 % and Olbert (2009). It is a BASIC version of an algorithm proposed by 
 % Bulirsch (1965) that computes the generalized complete elliptic 
 % integrals.
 %
 %    Inputs:
 %    1) kc    :                                                 [number]
 %    2) p     :                                                 [number] 
 %    3) a     :                                                 [number]
 %    4) b     :                                                 [number]
 %    5) Tol   : tolerance of the result                         [number]
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
 
 % ---------------------------------------------------------------------
 % February 9th, 2022                            Author: Federico Masiero
 % ---------------------------------------------------------------------
 
 %                                         Last check: February 9th, 2022
 
function C = ParallelBulirschCEL(kc,p,a,b,Tol)
 
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

% Preallocation of the vector containing the results
C = zeros(size(kc));

% Input check
% C(isnan(kc) | isnan(p) | isnan(a) | isnan(b)) = NaN;
% C(p == 0) = NaN;

% isBadInput = ( isnan(kc) | isnan(p) | isnan(a) | isnan(b) ) | p == 0;

kc( kc == 0 & b == 0 & p ~= 0 & p ~= 1 ) = 0.5e-10;

% D   = ...;       % number of significant digits 
% Tol = 10^(-D/2); % relative error
% relative error tolerance
eps = Tol;   

% k  = abs(kc(~isBadInput));
% pp = p(~isBadInput);
% aa = a(~isBadInput);
% bb = b(~isBadInput);
k  = abs(kc);
pp = p;
aa = a;
bb = b;

sz = size(bb);
em = ones(sz); % 1

% preallocation of auxiliary vectors
f = zeros(sz); q = f; g = f;

% if p > 0
M = pp > 0; m = pp < 0;
pp(M) = sqrt(p(M));
bb(M) = bb(M)./pp(M);
% if p < 0
f(m)  = kc(m).*kc(m);
q(m)  = 1 - f(m);
g(m)  = 1 - pp(m);
f(m)  = f(m) - pp(m);
q(m)  = q(m).*( bb(m) - a(m).*pp(m) );
pp(m) = sqrt(f(m)./g(m));
aa(m) = (a(m) - bb(m))./g(m);
bb(m) = aa(m).*pp(m) - q(m)./(g(m).*g(m).*pp(m));

f  = aa;
aa = aa + bb./pp;
g  = k./pp;
bb = 2.*(bb + f.*g);
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

% Special cases
% C( isinf(kc) | isinf(p) | (a == 0 & b == 0) ) = 0;
% C( kc == 0 & b ~= 0 ) = inf;
% C( kc == 0 & b == 0 & p == 1 ) = a( kc == 0 & b == 0 & p == 1 );
% C( kc == 1 & p == 0 ) = sign( b(kc == 1 & p == 0) )*inf;

% result is reshaped based on the size of the inputs
C = reshape(C,size_kc);