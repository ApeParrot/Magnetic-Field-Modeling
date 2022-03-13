function I10m1 = kausel_10m1(a,b,c,mode)

switch mode
        
    case 'HP' % from table 4 Kausel
        
        A = sqrt((a+b).^2+c.^2);
        B = sqrt((a-b).^2+c.^2);
        L1 = 1/2*(A-B);
        L2 = 1/2*(A+B);
        k  = L1./L2;
        nab = k.*a./b;
        nba = k.*b./a;

        K   = EllipticK(k);
        E   = EllipticE(k);
        Pab = EllipticPi(nab(a<=b),k(a<=b));
        Pba = EllipticPi(nba(a>b),k(a>b));
        
        I10m1 = 2*L2./(pi*a).*( E - K + a.^2./L2.^2.*K);
        I10m1(a<=b) = I10m1(a<=b) + 2*L2(a<=b)./(pi*a(a<=b)).*c(a<=b).^2./L2(a<=b).^2.*(K(a<=b)-Pab);
        I10m1(a>b)  = I10m1(a>b) + 2*L2(a>b)./(pi*a(a>b)).*c(a>b).^2./L2(a>b).^2.*(Pba-pi*L2(a>b)./(2*c(a>b)));
        
    otherwise % from table 3 Kausel - ENS-4.6
        
        k    = 2*sqrt(a.*b)./sqrt((a+b).^2+c.^2);
        beta = asin(sqrt(c.^2./((a-b).^2+c.^2)));
        
        K = EllipticK(k);
        E = EllipticE(k);
        L = pi/2*HeumanLambda(beta,k);
        
        I10m1 = 1./(pi*a).*( 2*sqrt(a.*b)./k.*E + (a.^2-b.^2).*k./(2*sqrt(a.*b)).*K ) + ...
                c./(pi*a).*sign(a-b).*L - c./a.*heaviside(a-b);
    
end